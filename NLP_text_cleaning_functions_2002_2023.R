# Functions for cleaning text for Natural language processing (NLP)
# Or personal use such as lingvist text upload

# Lingvist text upload where it keeps only dialogue from srt files
# Able to choose the minimium number of words per sentence to keep. 

lingvist_srt_text_cleaner <- function(srt_location, word_minimium = 0) {
    library(tidyverse)
  
    # Import the file into a variable
    subtitles <- read_lines(srt_location)
    
    # Convert into a data.frame
    subtitle_df <- data.frame(dialogue = subtitles, stringsAsFactors = FALSE)
    
    # Create string patterns to recognize time stamps and numbers because they begin with a number
    time_number_pattern <- "^[:digit:]" 
    bracket_word_pattern <- "^.*\\[(.*?)\\]"
    
    # Clean the subtitles
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
    writeLines(as.character(subtitle_clean$dialogue), paste0(tools::file_path_sans_ext(srt_location), "_word_min_", paste0(word_minimium), "_clean.txt"))
    
    # Return the cleaned data frame
    return(subtitle_clean)
}