import pandas as pd
from bs4 import BeautifulSoup
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from tqdm import tqdm
import requests
import json
import numpy as np
import re
import random
from difflib import get_close_matches

def import_top_songs():
    """
    Function that loads the top_songs.csv in a pandas dataframe.
    No input.
    Output: the dataframe with songs and authors.
    If there is no csv file with the songs stored, the function will alert the user.
    """

    try:
        df = pd.read_csv("top_songs.csv", index_col=0)
        return df
    except:
        print("No dataframe with top songs found. Run create_songs_dataframe() to create it.")
        return 0

def is_song_top(user_input, df):
    """
    Finds if a song is in the dataframe, or a similar one. It uses a built in algorithm that
    checks the similarity of sequences, through the Function get_close_matches.
    Input: the name of the song we would like to search for, and the dataframe.
    Output: the name of the song that is similar or equal, if it finds it; False if there is not.
    """
    #We extract the list of songs from the df, and make them lowecase. We also remove special characters
    #using the translate string method
    song_list = df["songs"].apply(lambda x: x.lower().translate({ord(c): "" for c in "/.()'\""}))

    #The input of the user also in lowecase
    user_input = user_input.lower()

    # The function will return the closest match in the list, or an empty list
    close_matches = get_close_matches(user_input, song_list, n=1, cutoff=0.9)

    return close_matches

def main():
    df = import_top_songs()

    user_input = input("Please insert the name of the song that you like: ")
    print("")
    input_song = is_song_top(user_input, df)  #This value will be [] if there are no similar songs

    if input_song == []:
        random_row = random.choice(range(len(df)))
        song = df.iloc[random_row, 0]
        artist = df.iloc[random_row, 1]
        print(f"Your song is not popular enough to be on our list. But we can recommend you {song}, by {artist}.")
    else:

        while True:  # Loop so we don't recommend the same song the user inputs.
            random_row = random.choice(range(len(df)))
            song = df.iloc[random_row, 0]
            artist = df.iloc[random_row, 1]

            if song.lower() != input_song:
                break

        print(f"You chose a top song! Another song you might like is {song}, by {artist}.")



if __name__=="__main__":
    main()
