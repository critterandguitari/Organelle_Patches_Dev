import sys

message = "hi"
message = sys.argv[1]

consumer_key        = '2SEgn2lzKl5KLQyzOQoxsTuK4'
consumer_secret     = '0AszFYptumhpn5zKwRRLu0VG8itawg6NPF1Xlkt3hMvUw9Kd3b'
access_token        = '943147478454603777-rSPo6Hmm7iRNrE8MMDwOpFfkgiOvRQv'
access_token_secret = '2uhBEFNhdI1mhdIDFYbW8S33bM2IgS4v5elutX78LrSeK'

from twython import Twython

twitter = Twython (
    consumer_key,
    consumer_secret,
    access_token,
    access_token_secret
)

twitter.update_status(status=message)
print "tweeted: " + message
