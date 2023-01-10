load("http.star", "http")
load("render.star", "render")
load("encoding/base64.star", "base64")

USER_INFO_URL = "http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user="
RECENT_TRACKS_URL = "https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user="

def main(config):
    api_key = config.get("api_key")
    user = config.get("user")

    # Create list for potentially missing elements
    missing_data = []

    # Add missing elements to the list
    if not api_key:
        missing_data.append('api_key')

    if not user:
        missing_data.append('user')

    # Generate the error message string
    # based on how many elements are missing
    if missing_data:
        error_message = 'MISSING: ' + missing_data[0]
        if len(missing_data) > 1:
            error_message += ', ' + missing_data[1]

        return render.Root(
            child = render.WrappedText(error_message)
        ) 
    
    # Get recent tracks data
    full_url = RECENT_TRACKS_URL + user + "&api_key=" + api_key + "&format=json"
    rep = http.get(full_url)
    if rep.status_code != 200:
        fail("Failed with %d", rep.status_code)

    last_played_song = rep.json()["recenttracks"]["track"][0]
    last_played_song_title = last_played_song["name"]

    return render.Root(
        child = render.Box(
            render.Row(
                expanded=True,
                main_align="space_evenly",
                cross_align="center",
                children = [
                    render.Text(last_played_song_title)
                ],
            )
        )
    )