#!/bin/tcsh
#
# richardd, 7 Oct 11
#
# converted to tcsh, 17 Oct 11
#
# example PBS script for berserker
#
# put this script in the same directory as the program
# you want to run.
#
# set the name of the job
#PBS -N massacrPAR_00_5
#
# set the output and error files
#PBS -o /home/navah/mOut.txt
#PBS -e /home/navah/mErr.txt
#PBS -m abe -M navah@uchicago.edu
# set the number of nodes to use, and number of processors
# to use per node
#PBS -l nodes=1:ppn=5
#
# or, if using only one node, you can do it this way too
## PBS -l ncpus=2
 
# import the environment we want.  You can determine what
# is available by running the command:
#
# module avail
#
# since the module command is a shell alias, we have to call
# it directly by its real name, and munge some options 
#
# in this example, I'm using the intel compilers and mvapich2
#
# bring in the module settings

source /etc/profile.d/modules.csh
module load intel/intel-12
module load mpi/mvapich/intel

# set PROGNAME to the name of your program
set PROGNAME=massacr
 
# figure out which mpiexec to use
set LAUNCH=/usr/mpi/intel/mvapich-1.2.0-qlc/bin/mpirun
 
# working directory
set WORKDIR=${HOME}

##/newtest/
 
set NCPU=`wc -l < $PBS_NODEFILE`
set NNODES=`uniq $PBS_NODEFILE | wc -l`
# set this to zero to turn OFF debugging, 1 to turn it on
set PERMDIR=${HOME}
set SERVPERMDIR=${PBS_O_HOST}:${PERMDIR}

set DEBUG=0
if ( $DEBUG ) then 
	echo ------------------------------------------------------
	echo ' This job is allocated on '${NCPU}' cpu(s)'
	echo 'Job is running on node(s): '
	#cat $PBS_NODEFILE
	echo ------------------------------------------------------
	echo PBS: qsub is running on $PBS_O_HOST
	echo PBS: originating queue is $PBS_O_QUEUE
	echo PBS: executing queue is $PBS_QUEUE
	echo PBS: working directory is $PBS_O_WORKDIR
	echo PBS: execution mode is $PBS_ENVIRONMENT
	echo PBS: job identifier is $PBS_JOBID
	echo PBS: job name is $PBS_JOBNAME
	echo PBS: node file is $PBS_NODEFILE
	echo PBS: number of nodes is $NNODES
	echo PBS: current home directory is $PBS_O_HOME
	echo PBS: PATH = $PBS_O_PATH
	echo ------------------------------------------------------
	echo workdir is $WORKDIR
	echo permdir is $PERMDIR
	echo servpermdir is $SERVPERMDIR
	echo ------------------------------------------------------
	echo 'Job is running on node(s): '
	cat $PBS_NODEFILE
	echo ------------------------------------------------------
	echo ${LAUNCH} -n {$NCPU} -f ${PBS_NODEFILE} ${WORKDIR}/${PROGNAME}
	echo ' '
	echo ' '
endif

echo $NCPU
echo $PBS_NODEFILE

# run the program
cd ${WORKDIR}
${LAUNCH} -np {$NCPU} -hostfile ${PBS_NODEFILE} ${WORKDIR}/${PROGNAME}

