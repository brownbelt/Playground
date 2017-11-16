add_executable(Sorter
    Sorter.cpp
)

add_executable(Knowing
    Knowing.cpp
)

add_executable(KSDemo
    KSDemo.c
)

target_link_libraries(KSDemo
    keystone
)