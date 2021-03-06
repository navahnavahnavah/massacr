! littleChunk.f90 
! gfortran -O3 -g -I/usr/local/include -c alteration.f90

! gfortran -O3 -g -I/usr/local/include -c littleChunk.f90
! gfortran -O3 -g -I/usr/local/include -o littleChunk littleChunk.o alteration.o -L/usr/local/lib -liphreeqc
! ./littleChunk

PROGRAM main
	use alteration
	
	implicit none
	
	! inputs
	real(8) :: temp, timestep, primary(5), secondary(28), solute(15) 
	
	! other stuff
	integer :: i, j
	real(8) ::  alt0(1,85) 
	
	! initial conditions
	timestep = 20000000000.0
	temp = 60.0
	
	primary(1) = 12.96 ! feldspar
	primary(2) = 6.96 ! augite
	primary(3) = 1.26 ! pigeonite
	primary(4) = .4 ! magnetite
	primary(5) = 96.77 ! basaltic glass
	
	secondary = 0.0
	
	solute(1) = 7.8 ! ph
	solute(2) = 8.451 ! pe
	solute(3) = 2.3e-3 ! Alk 1.6e-3 
	solute(4) = 2.200e-3 !1.2e-2 ! H2CO3
	solute(5) = 6.0e-3 ! Ca
	solute(6) = 2.0e-5 ! Mg
	solute(7) = 1.0e-3 ! Na
	solute(8) = 1.0e-4 ! K
	solute(9) = 1.2e-6 ! Fe
	solute(10) = 1.0e-4 ! 1.0e-4 ! S(6)
	solute(11) = 2.0e-4 ! Si
	solute(12) = 3.0e-4 ! Cl
	solute(13) = 1.0e-6 ! Al
	solute(14) = 2.200e-3 ! HCO3-
	solute(15) = 0.0 ! CO3-2
	
	write(*,*) "doing something..."
	
	do i=1,500
		write(*,*) i
		alt0 = alter(temp,timestep,primary,secondary,solute)
		write(*,*) alt0
		!PARSING
		solute = (/ alt0(1,2), alt0(1,3), alt0(1,4), alt0(1,5), alt0(1,6), &
		alt0(1,7), alt0(1,8), alt0(1,9), alt0(1,10), alt0(1,11), alt0(1,12), &
		alt0(1,13), alt0(1,14), alt0(1,15), 0.0D+00/)
		
		

		secondary = (/ alt0(1,16), alt0(1,18), alt0(1,20), &
		alt0(1,22), alt0(1,24), alt0(1,26), alt0(1,28), alt0(1,30), alt0(1,32), alt0(1,34), &
		alt0(1,36), alt0(1,38), alt0(1,40), alt0(1,42), alt0(1,44), alt0(1,46), alt0(1,48), &
		alt0(1,50), alt0(1,52), alt0(1,54), alt0(1,56), alt0(1,58), alt0(1,60), alt0(1,62), &
		alt0(1,64), alt0(1,66), alt0(1,68), alt0(1,70)/)
		
	
		primary = (/ alt0(1,72), alt0(1,74), alt0(1,76), alt0(1,78), alt0(1,80)/)
		
!		write(*,*) "calcite"
! 		write(*,*) secondary(16)
 		write(*,*) "pri 1"
 		write(*,*) primary(5)
	
	end do
	
END PROGRAM main