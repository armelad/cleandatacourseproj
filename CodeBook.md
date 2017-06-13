# General information
This project was performed with the following assumptions:
1. The data for the clean up and transformation is downloaded and saved into  the folder named **"dataset"** (i.e. no functions for download and unzip files were included).
2. External libraries _reshape2_, _plyr_, _dplyr_ and _data.table_ were used for the transformations to tidy dataset.

# The data
The following data is used in the transformations:
```
_/dataset/activity_labels.txt_ - activity labels
_/dataset/features.txt_ - measurements names
_/dataset/test/X_test.txt_ - the test data set
_/dataset/test/y_test.txt_ - the test labels
_/dataset/test/subject_test.txt_ - the test subject ids
_/dataset/train/X_train.txt_ - the train data set
_/dataset/train/y_train.txt_ - the train labels
_/dataset/train/subject_train.txt_ - the train subject ids

```

# Transformations 
The main transformation of the inital data to merge the training and the test datasets to create one dataset is performed via function **f**. The function contains the following local variables:

* **act_labels** - activity labels
* **ft_names** - names of the measurements
* **test_dst/train_dst** - Training and Test sets
* **test_activities/train_activities** - Train and Test activities
* **test_subjects/train_subjects**  - Train and Test subject ids

The function **f** uses cbind and rbind functions to merge the datasets and returns untidy merged training and test datasets.

The returned value is assined to variable **res** that is then used to assing descriptive activity names. This is achieved via conversion of the **activity** colum to the factor and _revalue_ function of the _plyr_ library is used for the conversion.

Then function _melt_ from the library _reshape2_ is used to tidy the dataset. Changing the _variable_ column name to measurement makes the data set look like this:

|	|subject	|activity	|measurement       |value        |
|-------|---------------|---------------|------------------|-------------|
|1	|2	        |standing	|tBodyAcc-mean()-X |0.25717778   |
|2	|2	        |standing	|tBodyAcc-mean()-X |0.28602671   |
|3	|2	        |standing	|tBodyAcc-mean()-X |0.27548482   |
|4	|2	        |standing	|tBodyAcc-mean()-X |0.27029822   |

Then _group_by_ function from _dplyr_ library is used to group the dataset by subject,activity,measurement and then summarized via _summarize_ _dplyr_ function to satsfy the requirement of the task #5 to create a separate dataset which is assigned to variable **res2**.

Resulting datasets are written on disk with _write.csv_ function:
**res** is written to dataset1.csv [limited to 1000 observations to save space]
**res2** is written to dataset2.csv

