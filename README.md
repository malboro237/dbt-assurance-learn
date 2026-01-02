Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Local development notes

The Airflow image is customized to include dbt and astronomer-cosmos; the compose file builds that image for the webserver and scheduler.

### Airflow connection and Cosmos cache

- The `airflow-init` service will create a connection named `postgres_dbt` (host: `host.docker.internal`) used by Cosmos to generate dbt profiles.
- To avoid stale generated profiles, the compose setup clears `/tmp/cosmos/profile/*` on initialization and on webserver/scheduler startup.

If you change the DB host or connection details, either update the `airflow-init` commands or clear `/tmp/cosmos/profile` so Cosmos regenerates the profiles from the current Airflow connection.

### CI notes (GitHub Actions)

- In CI (GitHub Actions) `host.docker.internal` is not available. Use environment variables to configure the DB host for dbt.
- A sample workflow is provided in `.github/workflows/dbt-ci.yml` that starts a Postgres service and sets:
	- `DBT_HOST=127.0.0.1`
	- `DBT_PORT=5432`
	- `DBT_USER=postgres`
	- `DBT_PASSWORD=dbt`
	- `DBT_DBNAME=dbt_learn`

The `profiles.yml` in this repo uses `env_var(...)` for host/port/user/password/database so CI can override them safely.
