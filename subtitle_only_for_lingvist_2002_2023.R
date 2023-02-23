# Remove the time stamps, remove all [sounds] in brackets. So it's only sentences.
# This allows me to import into Lingvist all in one go due to it's word limit.

library(pacman)
p_load(tidyverse)

# Define the location of the file
subtitle_location <- "subtitle/LupinS01E02.srt"

# Import the file into a value
subtitles <- read_lines(subtitle_location)

# Convert into a data.frame
subtitle_df <- data.frame(dialogue = subtitles, stringsAsFactors = FALSE)

# Create string patterns to recognize time stamps and numbers because they being with a number
time_number_pattern <- "^[:digit:]" 
bracket_word_pattern <- "^.*\\[(.*?)\\]"
word_minimium = 5


subtitle_clean <- subtitle_df %>%
  # This will remove all time stamps and the number from the dialogues
  dplyr::filter(!str_detect(string = dialogue, pattern = time_number_pattern)) %>%
  
  # Remove all words that are inside a bracket [] and - symbol
  dplyr::mutate(dialogue = str_remove(dialogue, bracket_word_pattern),
                dialogue = str_remove(dialogue, "\\-")) %>%
  
  # Remove all blank rows which have been created by removing the other lines
  dplyr::filter(!dialogue == "") %>%
  
  # Count the number of words each dialogue and mutate into a new column called words
  dplyr::mutate(words = str_count(dialogue, "\\w+")) %>%
  
  # Filter only the sentences where the word count is X or higher
  dplyr::filter(words >= word_minimium)

# Export the cleaned dialogue into a txt file
writeLines(as.character(subtitle_clean$dialogue), "Lupin_output_clean.txt")

