# SOURCES
eza, tldr(tlrc), fzf, delta, bat, zoxide https://www.youtube.com/watch?v=mmqDYw9C30I
# UNIX COMMANDS

lets transform out! (the json file)
## sed is a fun tool

lets replace foo with bar
lets replace foo or bar with foo,foo or bar,bar
show how its like vim find / replace
➜  dev-prod-2 git:(main) cat out | sed 's/: "\(.*\)",/: "\1,\1",/'
Expected
{"type": "foo,foo", "values": [1, 2, 3, 4, 5]}
{"type": "foo,foo", "values": [69, 420, 42, 69420]}
{"type": "bar,bar", "values": {"a": 42, "b": 69}}
{"type": "bar,bar", "values": {"a": 1337, "b": 420}}
{"type": "bar,bar", "values": {"a": 111, "b": 222}}

## find
list out files and do stuff

➜  dev-prod-2 git:(main) ✗ find . -maxdepth 1 -mindepth 1 -type f -exec grep -Hn "foo" {} \;
./out:1:{"type": "foo", "values": [1, 2, 3, 4, 5]}
./out:2:{"type": "foo", "values": [69, 420, 42, 69420]}   

## xargs
a great tool

➜  dev-prod-2 git:(main) ✗ echo "1\n2\n3" | xargs -I {} curl https://{}.com
curl: (6) Could not resolve host: 1.com
curl: (6) Could not resolve host: 2.com
curl: (6) Could not resolve host: 3.com

## parallel
such a great tool

lets write a file with the entries of 1 through 9, per line

1
2
3
4
5
6
7
8
9
now lets use parallel to control how fast it requests

➜  dev-prod-2 git:(main) ✗ cat count | parallel -j 5 "curl https://{}.com"


## Just a touch of awk
I don't know a lot of awk and you can do quite a bit, but the little i do know is really good

➜  dev-prod-2 git:(main) ✗ ps aux | grep vim | awk '{ sum += $2 } END { print sum }'


----------------------------------

## JQ
JQ, the hidden treasure in the family of CLI tools. This one has personaly saved me so much time its hard to qualify just how important it is

Lets create a file with the following content
{"type": "foo", "values": [1, 2, 3, 4, 5]}
{"type": "foo", "values": [69, 420, 42, 69420]}
{"type": "bar", "values": {"a": 42, "b": 69}}
{"type": "bar", "values": {"a": 1337, "b": 420}}
{"type": "bar", "values": {"a": 111, "b": 222}}


prettify logs
cat out | jq  # jq '' out


compact json
cat out | jq | jq -c


check this out
{
  "type": "foo",
  "values": [
    1,
    2,
    3,
    4,
    5
  ]
}
{
  "type": "foo",
  "values": [
    69,
    420,
    42,
    69420
  ]
}
{
  "type": "bar",
  "values": {
    "a": 42,
    "b": 69
  }
}
{
  "type": "bar",
  "values": {
    "a": 1337,
    "b": 420
  }
}
{
  "type": "bar",
  "values": {
    "a": 111,
    "b": 222
  }
}


lets look at the data
Lets sum ALL the foo's values arrays PER struct

{"type": "foo", "values": [1, 2, 3, 4, 5]}
{"type": "foo", "values": [69, 420, 42, 69420]}
{"type": "bar", "values": {"a": 42, "b": 69}}
{"type": "bar", "values": {"a": 1337, "b": 420}}
{"type": "bar", "values": {"a": 111, "b": 222}}
➜  dev-prod-2 git:(main) ✗ cat out | jq 'select(.type == "foo") | .values | add'


lets do it again
Lets sum ALL the foo's values arrays and add it as a key to type: foo valueSum

{"type": "foo", "values": [1, 2, 3, 4, 5]}
{"type": "foo", "values": [69, 420, 42, 69420]}
{"type": "bar", "values": {"a": 42, "b": 69}}
{"type": "bar", "values": {"a": 1337, "b": 420}}
{"type": "bar", "values": {"a": 111, "b": 222}}
➜  dev-prod-2 git:(main) ✗ cat out | jq 'select(.type == "foo") | .valueSet = (.values | add)'


We can filter out the valueSet now
➜  dev-prod-2 git:(main) ✗ cat out | jq 'select(.type == "foo") | .valueSet = (.values | add) | select(.valueSet > 20)'
