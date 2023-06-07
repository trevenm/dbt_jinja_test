##Welcome to my project for experimentation and exploration!

I have created a couple of elements to get some practice using specific dbt functionality with Snowflake.

###Data Sources:

    ####Billboard Top 100 
        - Every week, Billboard releases "The Hot 100" chart of songs that were trending on sales and airplay for that week. This dataset is a collection of all "The Hot 100" charts released since its inception in 1958.
        -https://www.kaggle.com/datasets/dhruvildave/billboard-the-hot-100-songs
        
    ####Top 850 Guitar Tabs 
        - Description of a guitar tab instance from the list of the top rated guitar tabs.
        -https://www.kaggle.com/datasets/thomaskonstantin/top-850-guitar-tabs


###Macros
    mighty
        Purpose
            -Simple macro to alter the band name "Van Halen"  to "The Mighty Van Halen" 
            -Illustrates using a macro to facilitate a common transformation that can be pointed to many data sources with a similar need
            -Implemented on the dim_artist model

###Models
    ####chart_movement
        Purpose
            -Identify which song had the largest movement in chart places from its lowest point to its highest point in a period
            -Data is based on a "key_artist", which allows the date ranges to begin from the first week the key_artist was on the charts
            -A loop is created to look at a rolling 12 week period for 100 weeks
    
    ####dim_artist
        Tests
            -Deliberately added a silly test for accepted values to illustrate the severity property in the config


