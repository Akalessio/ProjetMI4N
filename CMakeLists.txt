cmake_minimum_required(VERSION 3.26)
project(projetMI4N C)

set(CMAKE_C_STANDARD 11)

include_directories(
        include/
)

add_executable(projetMI4N
        src/main.c
        include/avl.h
        src/avl.c
        include/fonx.h
        src/fonx.c
        src/csvManaging.c
        include/csvManaging.h
)
