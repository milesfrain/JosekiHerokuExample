This project hosts the [Joseki.jl](https://github.com/amellnik/Joseki.jl)
example app on Heroku using a [julia buildpack](https://github.com/Optomatica/heroku-buildpack-julia).


Steps:
```
git clone https://github.com/milesfrain/JosekiHerokuExample.git
cd JosekiHerokuExample
HEROKU_APP_NAME=my-app-name
heroku create $HEROKU_APP_NAME --buildpack https://github.com/Optomatica/heroku-buildpack-julia.git
git push heroku master
heroku open -a $HEROKU_APP_NAME
heroku logs -tail -a $HEROKU_APP_NAME
```

Additional command line tests
```
curl $HEROKU_APP_NAME.herokuapp.com
curl -X GET $HEROKU_APP_NAME'.herokuapp.com/pow?x=3&y=4'
curl -X POST $HEROKU_APP_NAME'.herokuapp.com/bin' -H "Content-Type: application/json" --data '{"n":5,"k":2}'
```

I was previously attempting to host on heroku by uploading docker containers, but encountered lots of issues. Moved that troubleshooting effort to a [separate branch](https://github.com/milesfrain/JosekiHerokuExample/tree/dockerfile) in this repo.
