clean <- function() { 
  library(dplyr)
  library(purrr)
  #Read the labels
  activities = as_tibble(read_table(file = "./UCI HAR Dataset/activity_labels.txt", 
                                    col_names = c("activity_code", "activity"),
                                    col_types = list(col_integer(), col_character())))
  features = as_tibble(read_table2(file = "./UCI HAR Dataset/features.txt",
                                  col_names = c("column", "feature"),
                                  col_types = list(col_integer(), col_character())))
  subj = as_tibble(read.table(file = "./UCI HAR Dataset/train/subject_train.txt", 
                              col.names = "subject"))
  y = as_tibble(read.table(file = "./UCI HAR Dataset/train/Y_train.txt", sep = "\n",
                           col.names = "activity_code")) %>% left_join(activities, by = "activity_code") %>% select(-activity_code)
  
  x = as_tibble(read_table2(file = "./UCI HAR Dataset/train/X_train.txt", 
                            col_names = features$feature)) %>% select( matches("mean\\(|std\\("))
  train = bind_cols(subj, y)  %>% bind_cols(x)
  
  ##Do again for test data
  subj = as_tibble(read.table(file = "./UCI HAR Dataset/test/subject_test.txt", 
                              col.names = "subject"))
  y = as_tibble(read.table(file = "./UCI HAR Dataset/test/Y_test.txt", sep = "\n",
                           col.names = "activity_code")) %>% left_join(activities, by = "activity_code") %>% select(-activity_code)
  
  x = as_tibble(read_table2(file = "./UCI HAR Dataset/test/X_test.txt", 
                            col_names = features$feature)) %>% select( matches("mean\\(|std\\("))
  test = bind_cols(subj, y)  %>% bind_cols(x)
  
  ## Merge the two
  combined = bind_rows("test" = test, "train" = train, .id= "studytype")
  
  # Summarize#
  summary = combined %>% group_by(subject, activity) %>% select(-studytype)  %>% summarise_all(mean)

  write.csv(combined, file = "body_accelleration.csv")
  write.csv(summary, file = "body_summary.csv")
}

