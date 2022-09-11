**This repository is modified from a [skeleton](https://github.com/pravsels/melodic_ws) provided by [Praveen Selvaraj](https://github.com/pravsels), which was created by them for use by the students of the MSc Robotics and Computation 2021/22 cohort at UCL, for working on assignments requiring libraries and tools made available by this workspace.**  

**It has been modified to act as a workspace for the [selection_criteria](https://github.com/ahmedadamji/selection_criteria) package, created as part of the moderator's MSc Dissertation on the Study of the Effect of Selection Criteria of Point Features on SLAM Performance, at UCL.**  

To build the docker image:
```bash
docker build -t melodic_ws .
```
This builds a docker image from the Dockerfile script. <br />
**Note:** it expects the presence of a 'src' directory, even an empty one would do.

Once the docker image is built, run a container by using the shell script provided:
```bash
./run_docker_container.sh
````

To launch more instances of the same container (similar to multiple terminals):
```bash
docker exec -it <CONTAINER_ID> bash
```

To find your container ID, use:
```bash
docker ps
```
The unique container ID changes every time you launch a main container instance.


Once you've launched a container, you can use `catkin build` to build your workspace and `source devel/setup.bash` before launching your ROS nodes.
