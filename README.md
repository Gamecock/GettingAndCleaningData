# GettingAndCleaningData
Project

## Preparation
* Download the [data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
* Unzip into the working directory

## Part One
First Step in the analysis was is to merge the datasets.  I created the function `clean()` to gather all the data and return a tibble.

This was conducted in two parts, the test data and the train data following identical steps.
By inspecting the data we know that we have a final structure of the data set as:

Subject Activity  Meas1Mean, Meas1Std, Meas2Mean, Meas2Std ...

First I read subject  and Y, using the col name option to assign pretty names:
`col.names = "subject"` and `col.names = "activity_code"`.

Bind them together to get the first two columns.
`train = bind_cols(subj, y)`

That still is not very satisfying, the subjects are just numbers, but the activity codes have names in activity_labels.txt.  They can then be joined to the table, and the code column removed.
`train = train %>% left_join(activities) %>% select(-activity_code)`

The column names for the measurements are in features.txt, so we load them and use them as meaningful names when loading X_train.txt.  This generates a warning for deduplicating duplicate names, but we can safely ignore it becuase they are columns we are throwing away in the next step. Select only the columns with "mean()|std()" and add to the right side.

Then repeat for test.  Could do a loop, but hardly worth it for two iterations.

Stack the two data frames using "studytype" as a meaningful name for the variable tracking which table it came out of, and save the result.
`  bind_rows("test" = test, "train" = train, .id= "studytype")`

## Part Two
 
  Group the combined data by subject and activity
  Summarize each column by the mean of the data for each group.
    studytype should not be summarized, so remove that column.
