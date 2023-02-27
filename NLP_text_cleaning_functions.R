# Run function to clean text

source("NLP_text_cleaning_functions_2002_2023.R")

# Add the srt location into srt_location
# Add the desired word minimium in a sentence, default is 0
lingvist_srt_text_cleaner(srt_location = "subtitle/LupinS01E04.srt", word_minimium = 0)