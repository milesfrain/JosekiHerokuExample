# This example file taken from:
# https://github.com/amellnik/Joseki.jl/blob/1348cc354f898ef27bd0c1c67276dfaf66d84eac/examples/docker-simple.jl
# with some minor modifications

using Joseki, JSON, HTTP

### Create some endpoints

# This function takes two numbers x and y from the query string and returns x^y
# In this case they need to be identified by name and it should be called with
# something like 'http://localhost:8000/pow/?x=2&y=3'
function pow(req::HTTP.Request)
    j = HTTP.queryparams(HTTP.URI(req.target))
    has_all_required_keys(["x", "y"], j) || return error_responder(req, "You need to specify values for x and y!")
    # Try to parse the values as numbers.  If there's an error here the generic
    # error handler will deal with it.
    x = parse(Float32, j["x"])
    y = parse(Float32, j["y"])
    json_responder(req, x^y)
end

# This function takes two numbers n and k from a JSON-encoded request
# body and returns binomial(n, k)
function bin(req::HTTP.Request)
    j = try
        body_as_dict(req)
    catch err
        return error_responder(req, "I was expecting a json request body!")
    end
    has_all_required_keys(["n", "k"], j) || return error_responder(req, "You need to specify values for n and k!")
    json_responder(req, binomial(j["n"],j["k"]))
end

### Create and run the server

# Make a router and add routes for our endpoints.
endpoints = [
    (req -> "Hello", "GET", "/"),
    (pow, "GET", "/pow"),
    (bin, "POST", "/bin")
]
r = Joseki.router(endpoints)

port = parse(Int, ARGS[1])

# Fire up the server, binding to all ips
HTTP.serve(r, "0.0.0.0", port; verbose=true)
