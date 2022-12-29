load("http.star", "http")
load("render.star", "render")

USER_INFO_URL = "http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user="

def main(config):
    api_key = config.get("api_key")
    user = config.get("user")

    if not api_key or not user:
        return render.Root(
            child = render.Text("API Key Missing")
        ) 
    
    full_url = USER_INFO_URL + user + "&api_key=" + api_key + "&format=json"
    rep = http.get(full_url)
    if rep.status_code != 200:
        fail("Failed with %d", rep.status_code)

    realname = rep.json()["user"]["realname"]
    return render.Root(
        child = render.Text(realname)
    )