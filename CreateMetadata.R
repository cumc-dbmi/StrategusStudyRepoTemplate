
################################################################################
# INSTRUCTIONS: The code below assumes you have access to a PostgreSQL database
# and permissions to create tables in an existing schema specified by the
# resultsDatabaseSchema parameter.
# 
# See the Working with results section
# of the UsingThisTemplate.md for more details.
# 
# More information about working with results produced by running Strategus 
# is found at:
# https://ohdsi.github.io/Strategus/articles/WorkingWithResults.html
# ##############################################################################

resultsDatabaseSchema <- "results"
resultsDatabaseConnectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = Sys.getenv("OHDSI_RESULTS_DATABASE_SERVER"),
  user = Sys.getenv("OHDSI_RESULTS_DATABASE_USER"),
  password = Sys.getenv("OHDSI_RESULTS_DATABASE_PASSWORD")
)
conn <- DatabaseConnector::connect(
  connectionDetails = resultsDatabaseConnectionDetails
)
sql = paste("CREATE TABLE ", resultsDatabaseSchema, ".database_meta_data (
  cdm_source_name VARCHAR,
  cdm_source_abbreviation VARCHAR,
  cdm_holder VARCHAR,
  source_description VARCHAR,
  source_documentation_reference VARCHAR,
  cdm_etl_reference VARCHAR,
  source_release_date DATE,
  cdm_release_date DATE,
  cdm_version VARCHAR,
  cdm_version_concept_id INT,
  vocabulary_version VARCHAR,
  database_id VARCHAR NOT NULL,
  max_obs_period_end_date DATE,
  PRIMARY KEY(database_id)
);")

DatabaseConnector::executeSql(conn, sql)
DatabaseConnector::disconnect(conn)
