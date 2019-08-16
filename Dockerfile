FROM julia:1.1

ADD launch-server.jl /joseki_demo/
WORKDIR /joseki_demo

CMD julia -e 'using Pkg; pkg"add Joseki JSON HTTP"'; julia ./launch-server.jl
