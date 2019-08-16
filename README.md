This project aims to create the simplest Docker container from the example file found in https://github.com/amellnik/Joseki.jl and host it on Heroku.

This Docker container successfully launches on my local machine, but produces a Julia error when I attempt to run it on Heroku. It seems to be complaining that `verbose` is an unsupported keyword argument in `HTTP.serve`. Full error text at the bottom of this readme.


### Steps to reproduce the problem:

Checkout code
```
git clone https://github.com/milesfrain/JosekiHerokuExample.git
cd JosekiHerokuExample
```

#### Build container and deploy to Heroku
This assumes you have a Heroku account (may use free version) and the CLI is installed. Documentation on [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) and [Heroku Containers](https://devcenter.heroku.com/articles/container-registry-and-runtime).

Login to Heroku and container registry
```
heroku login
heroku container:login
```

Choose any name for your app

This is necessary for referring to the app in future commands.
```
HEROKU_APP_NAME="my-app-name"
```

Create an empty Heroku app workspace
```
heroku create $HEROKU_APP_NAME
```

Build container and push to app workspace

This command runs `docker build` and names the image to what Heroku requires so it finds your app workspace.
```
heroku container:push web --app $HEROKU_APP_NAME
```

Start the app
```
heroku container:release web --app $HEROKU_APP_NAME
```

Check app logs
```
heroku logs --tail --app $HEROKU_APP_NAME
```

Here we see this error:
```
LoadError: MethodError: no method matching listen(::getfield(HTTP.Handlers, Symbol("##4#5")){HTTP.Handlers.Router{Symbol("##363")}}, ::String, ::String; verbose=true)
Closest candidates are:
  listen(::Any, ::Union{String, IPAddr}) at /joseki_demo/.julia/packages/HTTP/U2ZVp/src/Servers.jl:206 got unsupported keyword argument "verbose"
```

Both [HTTP.listen](
https://juliaweb.github.io/HTTP.jl/stable/public_interface/#HTTP.Servers.listen
) and [HTTP.serve](
https://juliaweb.github.io/HTTP.jl/stable/public_interface/#HTTP.Handlers.serve
) support the `verbose` keyword argument.
The container execution logs are the same for local Docker and Heroku (until the error), and both install the same version of HTTP `[cd3eb016] + HTTP v0.8.4`.

Once the above error is resolved, we should be able to open the app in our browser.

```
heroku open --app $HEROKU_APP_NAME
```


#### Run the same Heroku app container locally
This works without errors!
```
docker run --rm -p 8000:8000 registry.heroku.com/$HEROKU_APP_NAME/web
```

You can test the server at
http://localhost:8000/pow/?x=2&y=3

If `ctrl-c` doesn't kill the container, you can stop it from another terminal with the following commands:

Find the container ID with `docker container ls`

Kill the container with `docker container stop <id>`, for example `docker container stop d469df85cd39`


#### To build and run the container without pushing to Heroku:

Build Docker container
```
docker build -t server-example .
```

Run Docker container
```
docker run --rm -p 8000:8000 server-example
```

Note that the image ID of `server-example` is the same as `registry.heroku.com/$HEROKU_APP_NAME/web` (assuming you followed the Heroku deployment steps and made no other project changes). Image IDs displayed with `docker image ls`.

### Full execution log and error message:

```
   Cloning default registries into `~/.julia`
   Cloning registry from "https://github.com/JuliaRegistries/General.git"
     Added registry `General` to `~/.julia/registries/General`
 Resolving package versions...
 Installed IniFile ──────── v0.5.0
 Installed Parsers ──────── v0.3.6
 Installed MbedTLS ──────── v0.6.8
 Installed Joseki ───────── v0.2.1
 Installed HTTP ─────────── v0.8.4
 Installed BinaryProvider ─ v0.5.6
 Installed JSON ─────────── v0.21.0
  Updating `~/.julia/environments/v1.1/Project.toml`
  [cd3eb016] + HTTP v0.8.4
  [682c06a0] + JSON v0.21.0
  [b588beb9] + Joseki v0.2.1
  Updating `~/.julia/environments/v1.1/Manifest.toml`
  [b99e7846] + BinaryProvider v0.5.6
  [cd3eb016] + HTTP v0.8.4
  [83e8ac13] + IniFile v0.5.0
  [682c06a0] + JSON v0.21.0
  [b588beb9] + Joseki v0.2.1
  [739be429] + MbedTLS v0.6.8
  [69de0a69] + Parsers v0.3.6
  [2a0f44e3] + Base64 
  [ade2ca70] + Dates 
  [8ba89e20] + Distributed 
  [b77e0a4c] + InteractiveUtils 
  [8f399da3] + Libdl 
  [56ddb016] + Logging 
  [d6f4376e] + Markdown 
  [a63ad114] + Mmap 
  [de0858da] + Printf 
  [9a3f8284] + Random 
  [ea8e919c] + SHA 
  [9e88b42a] + Serialization 
  [6462fe0b] + Sockets 
  [8dfed614] + Test 
  [4ec0a83e] + Unicode 
  Building MbedTLS → `~/.julia/packages/MbedTLS/X4xar/deps/build.log`
ERROR: LoadError: MethodError: no method matching listen(::getfield(HTTP.Handlers, Symbol("##4#5")){HTTP.Handlers.Router{Symbol("##363")}}, ::String, ::String; verbose=true)
Closest candidates are:
  listen(::Any, ::Union{String, IPAddr}) at /joseki_demo/.julia/packages/HTTP/U2ZVp/src/Servers.jl:206 got unsupported keyword argument "verbose"
  listen(::Any, ::Union{String, IPAddr}, !Matched::Integer; sslconfig, tcpisvalid, server, reuseaddr, connection_count, rate_limit, reuse_limit, readtimeout, verbose) at /joseki_demo/.julia/packages/HTTP/U2ZVp/src/Servers.jl:206
  listen(::Any) at /joseki_demo/.julia/packages/HTTP/U2ZVp/src/Servers.jl:206 got unsupported keyword argument "verbose"
Stacktrace:
 [1] #serve#3(::Bool, ::Base.Iterators.Pairs{Symbol,Bool,Tuple{Symbol},NamedTuple{(:verbose,),Tuple{Bool}}}, ::Function, ::HTTP.Handlers.Router{Symbol("##363")}, ::String, ::String) at /joseki_demo/.julia/packages/HTTP/U2ZVp/src/Handlers.jl:345
 [2] (::getfield(HTTP.Handlers, Symbol("#kw##serve")))(::NamedTuple{(:verbose,),Tuple{Bool}}, ::typeof(HTTP.Handlers.serve), ::HTTP.Handlers.Router{Symbol("##363")}, ::String, ::String) at ./none:0
 [3] top-level scope at none:0
 [4] include at ./boot.jl:326 [inlined]
 [5] include_relative(::Module, ::String) at ./loading.jl:1038
 [6] include(::Module, ::String) at ./sysimg.jl:29
 [7] exec_options(::Base.JLOptions) at ./client.jl:267
 [8] _start() at ./client.jl:436
in expression starting at /joseki_demo/launch-server.jl:46
```

When running the container locally, the last three lines are:
```
  [4ec0a83e] + Unicode 
  Building MbedTLS → `~/.julia/packages/MbedTLS/X4xar/deps/build.log`
[ Info: Listening on: 0.0.0.0:8000
```


### Other notes:

It's probably better Docker form to move the package dependencies installation step `julia -e 'using Pkg; pkg"add Joseki JSON HTTP"'` from the `CMD` block to a `RUN` block in order to store more in the container, but this also has the same outcome (works in local Docker and fails in Heroku). Moving package installation to `CMD` allows more flexibility in debugging, since you can easily experiment with different package installation strategies in the launch commands without deploying a new container.

It's probably better Julia form to create a module with dependencies listed in a `Project.toml` and `Manifest.toml`, but this shouldn't be necessary for a simple example of launching a server script from a container.

