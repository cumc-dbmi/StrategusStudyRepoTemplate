################################################################################
# INSTRUCTIONS: This script assumes you have cohorts you would like to use in an
# ATLAS instance. Please note you will need to update the baseUrl to match
# the settings for your enviroment. You will also want to change the 
# CohortGenerator::saveCohortDefinitionSet() function call arguments to identify
# a folder to store your cohorts. This code will store the cohorts in 
# "inst/sampleStudy" as part of the template for reference. You should store
# your settings in the root of the "inst" folder and consider removing the 
# "inst/sampleStudy" resources when you are ready to release your study.
# 
# See the Download cohorts section
# of the UsingThisTemplate.md for more details.
# ##############################################################################

library(dplyr)
baseUrl <- Sys.getenv("ATLAS_BASE_URL")
# Use this if your WebAPI instance has security enables
ROhdsiWebApi::authorizeWebApi(
  baseUrl = baseUrl,
  authMethod = "ad",
  webApiUser = Sys.getenv("ATLAS_WEBAPI_USER"),
  webApiPassword = Sys.getenv("ATLAS_WEBAPI_PASSWORD")
)

cohortDefinitionSet <- ROhdsiWebApi::exportCohortDefinitionSet(
  baseUrl = baseUrl,
  cohortIds = c(
    17, # all events of AMI
    16, # all events of angioedema
    15, # hypertension
    14, # ARB
    13 # ACEi
  ),
  generateStats = TRUE
)

# Save the cohort definition set
# NOTE: Update settingsFileName, jsonFolder and sqlFolder
# for your study.
CohortGenerator::saveCohortDefinitionSet(
  cohortDefinitionSet = cohortDefinitionSet,
  settingsFileName = "inst/sampleStudy/Cohorts.csv",
  jsonFolder = "inst/sampleStudy/cohorts",
  sqlFolder = "inst/sampleStudy/sql/sql_server",
)


# Download and save the negative control outcomes
negativeControlOutcomeCohortSet <- ROhdsiWebApi::getConceptSetDefinition(
  conceptSetId = 16,
  baseUrl = baseUrl
) %>%
  ROhdsiWebApi::resolveConceptSet(
    baseUrl = baseUrl
  ) %>%
  ROhdsiWebApi::getConcepts(
    baseUrl = baseUrl
  ) %>%
  rename(outcomeConceptId = "conceptId",
         cohortName = "conceptName") %>%
  mutate(cohortId = row_number() + 100) %>%
  select(cohortId, cohortName, outcomeConceptId)

# NOTE: Update file location for your study.
CohortGenerator::writeCsv(
  x = negativeControlOutcomeCohortSet,
  file = "inst/sampleStudy/negativeControlOutcomes.csv",
  warnOnFileNameCaseMismatch = F
)
