!batchControl.f90

! gfortran -c -I/usr/local/include -L/usr/local/lib -liphreeqc batchControl.f90
! gfortran -I/usr/local/include -L/usr/local/lib -liphreeqc batchControl.o
! ./a.out

! gfortran -I/usr/local/include -L/usr/local/lib -liphreeqc batchControl.o -o c10


program batchControl
!use globals
INCLUDE "IPhreeqc.f90.inc"

!implicit none
INTEGER(KIND=4) :: id, all=84, its=50, its0=1
INTEGER(KIND=4) :: i, j, jj
CHARACTER(LEN=52000) :: line
character(len=51200) :: inputz0
character(len=4) :: fake_in
real(8) :: alter(1,59), mix1= 0.9, mix2=0.1
real(8), allocatable :: outmat(:,:)

! REAL GRABS
real(8) :: glass ! primary
real(8) :: siderite ! secondary
real(8) :: temp, timestep, primary(5), secondary(28), solute(14), solute0(14) ! important information

! STRINGS
character(len=50) :: s_siderite, s_kaolinite, s_goethite, s_dolomite, s_celadonite ! secondary
character(len=50) :: s_sio2, s_albite, s_calcite, s_mont_na, s_smectite, s_saponite ! secondary
character(len=50) :: s_stilbite, s_dawsonite, s_magnesite, s_clinoptilolite, s_pyrite ! secondary
character(len=50) :: s_quartz, s_kspar, s_saponite_na, s_nont_na, s_nont_mg, s_nont_k ! secondary
character(len=50) :: s_nont_h, s_nont_ca, s_muscovite, s_mesolite, s_hematite, s_diaspore ! 
character(len=50) :: s_feldspar, s_pigeonite, s_augite, s_glass, s_magnetite ! primary
character(len=50) :: s_temp, s_timestep ! important information
character(len=50) :: s_ph, s_ca, s_mg, s_na, s_k, s_fe, s_s, s_si, s_cl, s_al, s_alk, s_co2 ! solutes
character(len=50) :: s_hco3, s_co3
real(8) :: water
character(len=50) :: s_water

! command line arguments
character(len=100) :: intemp
character(len=100) :: infile
integer :: in

in = iargc()
call getarg(1,intemp)
call getarg(2,infile)


glass = 2.0
siderite = 0.0



! function alter ( temp, timestep, primary, secondary, solute )
! INITIALIZE CHEMISTRY, STUFF DONE THAT IS PASSED TO WHAT WAS ORIGINALLY A SUBROUTINE OR WHATEVER
primary(1) = 129.6 ! feldspar
primary(2) = 69.6 ! augite
primary(3) = 12.6 ! pigeonite
primary(4) = 4.0 ! magnetite
primary(5) = 967.7 ! basaltic glass


secondary(:) = 0.0

!solute(1) = 7.5 ! ph
solute(2) = 6.0e-4 ! Ca
solute(3) = 2.0e-5 ! Mg
solute(4) = 1.0e-3 ! Na
solute(5) = 1.0e-4 ! K
solute(6) = 1.2e-6 ! Fe
solute(7) = 1.0e-4 ! S(6)
solute(8) = 2.0e-4 ! Si
solute(9) = 3.0e-4 ! Cl
solute(10) = 1.0e-6 ! Al
solute(11) = 10.0e-3 ! Alk 1.6e-3 
solute(12) = 105.00e-3 !1.2e-2 ! H2CO3
solute(13) = 0.0 ! HCO3-
solute(14) = 0.0 ! CO3-2

 solute(1) = 8.22 ! ph
! solute(2) = 1.094e-02 ! Ca
! solute(3) = 5.639e-02 ! Mg
! solute(4) = 4.859e-01 ! Na
! solute(5) = 1.078e-02 ! K
! solute(6) = 6.319e-06 ! Fe
! solute(7) = 2.933e-02 ! S(6)
! solute(8) = 1.003e-02 ! Si
! solute(9) =  5.658e-01 ! Cl
! solute(10) = 1.0e-6 ! Al
! solute(11) = 1.230e-02 ! Alk

solute0 = solute



! flushing timestep
timestep = 3.14e9
temp = 10.0
water = 5.0

! SOLUTES TO STRINGS
write(s_ph,'(F25.10)') solute(1)
write(s_ca,'(F25.10)') solute(2)
write(s_mg,'(F25.10)') solute(3)
write(s_na,'(F25.10)') solute(4)
write(s_k,'(F25.10)') solute(5)
write(s_fe,'(F25.10)') solute(6)
write(s_s,'(F25.10)') solute(7)
write(s_si,'(F25.10)') solute(8)
write(s_cl,'(F25.10)') solute(9)
write(s_al,'(F25.10)') solute(10)
write(s_alk,'(F25.10)') solute(11)
write(s_co2,'(F25.10)') solute(12)
write(s_hco3,'(F25.10)') solute(13)
write(s_co3,'(F25.10)') solute(14)
write(s_water,'(F25.10)') water

! PRIMARIES TO STRINGS
write(s_feldspar,'(F25.10)') primary(1)
write(s_augite,'(F25.10)') primary(2)
write(s_pigeonite,'(F25.10)') primary(3)
write(s_magnetite,'(F25.10)') primary(4)
write(s_glass,'(F25.10)') primary(5)

! SECONDARIES TO STRINGS
write(s_siderite,'(F25.10)') secondary(1)
write(s_kaolinite,'(F25.10)') secondary(2)
write(s_goethite,'(F25.10)') secondary(3)
write(s_dolomite,'(F25.10)') secondary(4)
write(s_celadonite,'(F25.10)') secondary(5)
write(s_sio2,'(F25.10)') secondary(6)
write(s_albite,'(F25.10)') secondary(7)
write(s_calcite,'(F25.10)') secondary(8)
write(s_mont_na,'(F25.10)') secondary(9)
write(s_smectite,'(F25.10)') secondary(10)
write(s_saponite,'(F25.10)') secondary(11)
write(s_stilbite,'(F25.10)') secondary(12)
write(s_dawsonite,'(F25.10)') secondary(13)
write(s_magnesite,'(F25.10)') secondary(14)
write(s_clinoptilolite,'(F25.10)') secondary(15)
write(s_pyrite,'(F25.10)') secondary(16)
write(s_quartz,'(F25.10)') secondary(17)
write(s_kspar,'(F25.10)') secondary(18)
write(s_saponite_na,'(F25.10)') secondary(19)
write(s_nont_na,'(F25.10)') secondary(20)
write(s_nont_mg,'(F25.10)') secondary(21)
write(s_nont_k,'(F25.10)') secondary(22)
write(s_nont_h,'(F25.10)') secondary(23)
write(s_nont_ca,'(F25.10)') secondary(24)
write(s_muscovite,'(F25.10)') secondary(25)
write(s_mesolite,'(F25.10)') secondary(26)
write(s_hematite,'(F25.10)') secondary(27)
write(s_diaspore,'(F25.10)') secondary(28)

! OTHER INFORMATION TO STRINGS
write(s_temp,'(F25.10)') temp
write(s_timestep,'(F25.10)') timestep






! NOW YOU HAVE TO LOOP THIS ENTIRE THING AND ADD EACH OUTPUT TO A MATRIX EACH TIME
allocate(outmat(its*its0+1,all))
do j = 1,its

! ----------------------------------%%
! INITIAL AQUEOUS PHASE CONSITUENTS
! ----------------------------------%%

! inputz0 = "SOLUTION 1 " //NEW_LINE('')// &
! &"    pH " // trim(s_pH) //NEW_LINE('')// &
! &"    units   mol/kgw" //NEW_LINE('')// &
! &"    temp" // trim(s_temp) //NEW_LINE('')// &
! &"    Ca " // trim(s_ca) //NEW_LINE('')// &
! &"    Mg " // trim(s_mg) //NEW_LINE('')// &
! &"    Na " // trim(s_na) //NEW_LINE('')// &
! &"    K " // trim(s_k) //NEW_LINE('')// &
! &"    Fe " // trim(s_fe) //NEW_LINE('')// &
! &"    S(6) "// trim(s_s) // " as SO4" //NEW_LINE('')// &
! &"    Si " // trim(s_si) //NEW_LINE('')// &
! &"    Cl " // trim(s_cl) //NEW_LINE('')// &
! &"    Al " // trim(s_al) //NEW_LINE('')// &
! &"    Alkalinity " // trim(s_alk) // " as HCO3" //NEW_LINE('')// &
! &"    -water		.5	# kg" //NEW_LINE('')// &
! &"END" //NEW_LINE('')// &

! water composition is nordstrom et al. 1979 seawater
!  inputz0 = "SOLUTION 1 " //NEW_LINE('')// &
!  &"    pH 8.22" //NEW_LINE('')// &
!  &"    units   ppm" //NEW_LINE('')// &
!  &"    temp 20.0" //NEW_LINE('')// &
!  &"    Ca 412.3" //NEW_LINE('')// &
!  &"    Mg 1291.8" //NEW_LINE('')// &
!  &"    Na 10768.0" //NEW_LINE('')// &
!  &"    K 399.1" //NEW_LINE('')// &
!  &"    Fe .002" //NEW_LINE('')// &
!  &"    Mn .0002" //NEW_LINE('')// &
!  &"    S(6) 2712.0 as SO4" //NEW_LINE('')// &
!  &"    Si 4.28" //NEW_LINE('')// &
!  &"    Cl 19353.0" //NEW_LINE('')// &
!  &"    NO3 0.29" //NEW_LINE('')// &
!  &"    NH4 0.03" //NEW_LINE('')// &
!  &"    Alkalinity 141.682 as HCO3" //NEW_LINE('')// &
!  &"    -water		5.0	# kg" //NEW_LINE('')// &
!  &"END" //NEW_LINE('')// &
 
inputz0 = "SOLUTION 1 " //NEW_LINE('')// &
&"    pH " // trim(s_pH) //NEW_LINE('')// &
!&"    pe 8.451 " //NEW_LINE('')// &
&"    units   mol/kgw" //NEW_LINE('')// &
!&"    temp 10.0"  //NEW_LINE('')// &
&"    temp " // intemp //NEW_LINE('')// &
&"    Ca " // trim(s_ca) //NEW_LINE('')// &
&"    Mg " // trim(s_mg) //NEW_LINE('')// &
&"    Na " // trim(s_na) //NEW_LINE('')// &
&"    K " // trim(s_k) //NEW_LINE('')// &
&"    Fe " // trim(s_fe) //NEW_LINE('')// &
&"    S(6) "// trim(s_s) // " as SO4" //NEW_LINE('')// &
&"    Si " // trim(s_si) //NEW_LINE('')// &
&"    Cl " // trim(s_cl) //NEW_LINE('')// &
&"    Al " // trim(s_al) //NEW_LINE('')// &
&"    C " // trim(s_co2) //NEW_LINE('')// &
!&"    Alkalinity " // trim(s_alk) // " as HCO3" //NEW_LINE('')// &
!&"    -water		5.0	# kg" //NEW_LINE('')// &
&"    -water "// trim(s_water) //NEW_LINE('')// &
&"END" //NEW_LINE('')// &

! ----------------------------------%%
! HYDROTHERMAL MINERAL CHOICES
! ----------------------------------%%
  
&"EQUILIBRIUM_PHASES 1" //NEW_LINE('')// &
!&"    CO2(g) -3.25 100" //NEW_LINE('')// &
&"    Kaolinite 0.0 " // trim(s_kaolinite) //NEW_LINE('')// &
&"    Goethite 0.0 " // trim(s_goethite) //NEW_LINE('')// &
&"    Celadonite 0.0 " // trim(s_celadonite) //NEW_LINE('')// &
&"    SiO2(am) 0.0 " // trim(s_sio2) //NEW_LINE('')// &
&"    Albite 0.0 " // trim(s_albite) //NEW_LINE('')// &
&"    Calcite 0.0 " // trim(s_calcite) //NEW_LINE('')// &
&"    Montmor-Na 0.0 " // trim(s_mont_na) //NEW_LINE('')// &
&"    Saponite-Mg 0.0 " // trim(s_saponite) //NEW_LINE('')// &
&"    Stilbite 0.0 " // trim(s_stilbite) //NEW_LINE('')// &
&"    Clinoptilolite-Ca 0.0 " // trim(s_clinoptilolite) //NEW_LINE('')// &
&"    Pyrite 0.0 " // trim(s_pyrite) //NEW_LINE('')// &
&"    Quartz 0.0 " // trim(s_quartz) //NEW_LINE('')// &
&"    K-Feldspar 0.0 " // trim(s_kspar) //NEW_LINE('')// &

! NEW MINS

! &"    Dolomite 0.0 " // trim(s_dolomite) //NEW_LINE('')// &
 &"    Saponite-Na 0.0 " // trim(s_saponite_na) //NEW_LINE('')// &
 &"    Nontronite-Na 0.0 " // trim(s_nont_na) //NEW_LINE('')// &
 &"    Nontronite-Mg 0.0 " // trim(s_nont_mg) //NEW_LINE('')// &
 &"    Nontronite-K 0.0 " // trim(s_nont_k) //NEW_LINE('')// &
 &"    Nontronite-H 0.0 " // trim(s_nont_h) //NEW_LINE('')// &
 &"    Nontronite-Ca 0.0 " // trim(s_nont_ca) //NEW_LINE('')// &
 &"    Muscovite 0.0 " // trim(s_muscovite) //NEW_LINE('')// &
 &"    Mesolite 0.0 " // trim(s_mesolite) //NEW_LINE('')// &
 &"    Hematite 0.0 " // trim(s_hematite) //NEW_LINE('')// &
 &"    Diaspore 0.0 " // trim(s_diaspore) //NEW_LINE('')// &


!  &"    Dawsonite 0.0 " // trim(s_dawsonite) //NEW_LINE('')// &
!  &"    Magnesite 0.0 " // trim(s_magnesite) //NEW_LINE('')// &
!  &"    Quartz 0.0 0.0" //NEW_LINE('')// &
!  &"    Smectite-high-Fe-Mg 0.0 " // trim(s_smectite) //NEW_LINE('')// &
!  &"    Dolomite 0.0 " // trim(s_dolomite) //NEW_LINE('')// &
!&"    Siderite 0.0 " // trim(s_siderite) //NEW_LINE('')// &

! ----------------------------------%%
! CALCULATE POROSITY AND STUFF
! ----------------------------------%%

&"CALCULATE_VALUES" //NEW_LINE('')// &

&"R(sum)" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"10 sum = EQUI('Stilbite')*832.2/2.15 + EQUI('SiO2(am)')*60.0/2.62" //&
&"+ EQUI('Kaolinite')*258.2/2.6 + EQUI('Albite')*262.3/2.62" // &
&"+ EQUI('Saponite-Mg')*385.537/2.4 + EQUI('Celadonite')*396.8/3.0" // &
&"+ EQUI('Clinoptilolite-Ca')*1344.49/2.62 + EQUI('Pyrite')*120.0/4.84" // &
&"+ EQUI('Montmor-Na')*103.8/5.3 + EQUI('Goethite')*88.8/3.8" // &
&"+ EQUI('Dolomite')*184.3/2.84 + EQUI('Smectite-high-Fe-Mg')*425.7/2.7" // &
&"+ EQUI('Dawsonite')*144.0/2.42 + EQUI('Magnesite')*84.3/3.0" // &
&"+ EQUI('Siderite')*115.8/3.96 + EQUI('Calcite')*100.0/2.71" // &
&"+ EQUI('Quartz')*60.0/2.62 + EQUI('K-Feldspar')*193.0/2.56" // &
&"+ KIN('Plagioclase')*270.0/2.68 + KIN('Augite')*230.0/3.4" // &
&"+ KIN('Pigeonite')*239.6/3.38 + KIN('Magnetite')*231.0/5.15" // &
&"+ KIN('BGlass')*46.5/2.92" // &
&"" //NEW_LINE('')// &
&"100 SAVE sum" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &
  
&"R(phi)" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"10 phi = 1.0-(CALC_VALUE('R(sum)')/(CALC_VALUE('R(sum)')+(TOT('water')*1000.0)))" //&
!&"10 phi = 0.1" //&
&"" //NEW_LINE('')// &
&"100 SAVE phi" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &

&"R(water_volume)" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"10 water_volume = TOT('water')" //&
&"" //NEW_LINE('')// &
&"100 SAVE water_volume" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &
  

&"R(rho_s)" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
!&"10 rho_s = CALC_VALUE('R(sum)')" //NEW_LINE('')// &
&"10 rho_s = EQUI('Stilbite')*2.15 + EQUI('SiO2(am)')*2.62" //&
&"+ EQUI('Kaolinite')*2.6 + EQUI('Albite')*2.62" // &
&"+ EQUI('Saponite-Mg')*2.4 + EQUI('Celadonite')*3.0" // &
&"+ EQUI('Clinoptilolite-Ca')*2.62 + EQUI('Pyrite')*4.84" // &
&"+ EQUI('Montmor-Na')*5.3 + EQUI('Goethite')*3.8" // &
&"+ EQUI('Dolomite')*2.84 + EQUI('Smectite-high-Fe-Mg')*2.7" // &
&"+ EQUI('Dawsonite')*2.42 + EQUI('Magnesite')*3.0" // &
&"+ EQUI('Siderite')*3.96 + EQUI('Calcite')*2.71" // &
&"+ EQUI('Quartz')*2.62 + EQUI('k-Feldspar')*2.56" // &
&"+ KIN('Plagioclase')*2.68 + KIN('Augite')*3.4" // &
&"+ KIN('Pigeonite')*3.38 + KIN('Magnetite')*5.15" // &
&"+ KIN('BGlass')*2.92" //NEW_LINE('')// &
&"20 rho_s = rho_s/ (EQUI('Stilbite') + EQUI('SiO2(am)')" //&
&"+ EQUI('Kaolinite') + EQUI('Albite')" // &
&"+ EQUI('Saponite-Mg') + EQUI('Celadonite')" // &
&"+ EQUI('Clinoptilolite-Ca') + EQUI('Pyrite')" // &
&"+ EQUI('Montmor-Na') + EQUI('Goethite')" // &
&"+ EQUI('Dolomite') + EQUI('Smectite-high-Fe-Mg')" // &
&"+ EQUI('Dawsonite') + EQUI('Magnesite')" // &
&"+ EQUI('Siderite') + EQUI('Calcite')" // &
&"+ EQUI('Quartz') + EQUI('K-Feldspar')" // &
&"+ KIN('Plagioclase') + KIN('Augite')" // &
&"+ KIN('Pigeonite') + KIN('Magnetite')" // &
&"+ KIN('BGlass'))" //NEW_LINE('')// &
!  &"20 rho_s = rho_s / (EQUI('Stilbite')*832.2 + EQUI('SiO2(am)')*60.0" //&
!  &"+ EQUI('Kaolinite')*258.2 + EQUI('Albite')*262.3" // &
!  &"+ EQUI('Saponite-Mg')*385.537 + EQUI('Celadonite')*396.8" // &
!  &"+ EQUI('Clinoptilolite-Ca')*1344.49 + EQUI('Pyrite')*120.0" // &
!  &"+ EQUI('Hematite')*103.8 + EQUI('Goethite')*88.8" // &
!  &"+ EQUI('Dolomite')*184.3 + EQUI('Smectite-high-Fe-Mg')*425.7" // &
!  &"+ EQUI('Dawsonite')*144.0 + EQUI('Magnesite')*84.3" // &
!  &"+ EQUI('Siderite')*115.8 + EQUI('Calcite')*100.0" // &
!  &"+ KIN('Plagioclase')*270.0 + KIN('Augite')*230.0" // &
!  &"+ KIN('Pigeonite')*239.6 + KIN('Magnetite')*231.0" // &
!  &"+ KIN('BGlass')*46.5)" //NEW_LINE('')// &
&"30 rho_s = rho_s * 1000000.0" //NEW_LINE('')// &
&"100 SAVE rho_s" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &
  
  
&"R(s_sp)" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
!&"10 s_sp = (CALC_VALUE('R(phi)')/(1.0-CALC_VALUE('R(phi)')))*400.0/CALC_VALUE('R(rho_s)')" //&
&"10 s_sp = 1.53e-5" //&
&"" //NEW_LINE('')// &
&"100 SAVE s_sp" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &

! ----------------------------------%%
! PRIMARY (KINETIC) CONSTITUENTS
! ----------------------------------%%

&"KINETICS" //NEW_LINE('')// &
&"Plagioclase" //NEW_LINE('')// &
&"-m0 " // trim(s_feldspar) //NEW_LINE('')// &
&"Augite" //NEW_LINE('')// &
&"-m0 " // trim(s_augite) //NEW_LINE('')// &
&"Pigeonite" //NEW_LINE('')// &
&"-m0 " // trim(s_pigeonite) //NEW_LINE('')// &
&"Magnetite" //NEW_LINE('')// &
&"-m0 " // trim(s_magnetite) //NEW_LINE('')// &
&"BGlass" //NEW_LINE('')// &
&"-f CaO 0.025 Fe2O3 0.0475 MgO 0.065 " //&
& "Na2O 0.0125 K2O 0.005 Al2O3 0.034999 SiO2 0.5" //NEW_LINE('')// &
&"-m0 " // trim(s_glass) //NEW_LINE('')// &
!&"-m0 0.0"  //NEW_LINE('')// &

! SO2 0.003

&"    -step " // trim(s_timestep) // " in 1" //NEW_LINE('')// &
!&"    -step 3.14e11 in 1" //NEW_LINE('')// &

&"INCREMENTAL_REACTIONS true" //NEW_LINE('')// &

&"Use solution 1" //NEW_LINE('')// &

    
! ----------------------------------%%
! KINETIC DISSOLUTION RATE LAWS
! ----------------------------------%%
	
&"RATES" //NEW_LINE('')// &

&"BGlass" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"    10 rate0=M*46.5*CALC_VALUE('R(s_sp)')*0.1*(1e4)*(2.51189e-6)*exp(-25.5/(.008314*TK))" // &
&"*(((ACT('H+')^3)/(ACT('Al+3')))^.333)" //NEW_LINE('')// &
&"    20 save rate0 * time" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &

&"Plagioclase" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"    10 rate = (1-SR('Plagioclase'))*M*270.0*CALC_VALUE('R(s_sp)')*0.1*(((1.58e-9)"//&
&"*exp(-53.5/(.008314*TK))*(ACT('H+')^0.541) +(3.39e-12)*exp(-57.4/(.008314*TK)) +"//&
&"(4.78e-15)*exp(-59.0/(.008314*TK))*(ACT('H+'))^-0.57))"//NEW_LINE('')//&
&"    20 save rate * time"//NEW_LINE('')//&
&"-end" //NEW_LINE('')// &

&"Augite" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"    10 rate0 = (1-SR('Augite'))*M*230.0*CALC_VALUE('R(s_sp)')*0.1*(((1.58e-7)" // &
&"*exp(-78.0/(.008314*TK))*(ACT('H+')^0.7)+(1.07e-12)*exp(-78.0/(.008314*TK))))" //NEW_LINE('')// & 
&"    20 save rate0 * time" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &

&"Pigeonite" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"    10 rate0 = (1-SR('Pigeonite'))*M*236.0*CALC_VALUE('R(s_sp)')*0.1*(((1.58e-7)" // &
&"*exp(-78.0/(.008314*TK))*(ACT('H+')^0.7)+(1.07e-12)*exp(-78.0/(.008314*TK))))"//NEW_LINE('')// &
&"    20 save rate0 * time" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &

&"Magnetite" //NEW_LINE('')// &
&"-start" //NEW_LINE('')// &
&"    10 rate0 = (1-SR('Magnetite'))*M*231.0*CALC_VALUE('R(s_sp)')*0.1*(((2.57e-9)" // &
&"*exp(-18.6/(.008314*TK))*(ACT('H+')^0.279)+(1.66e-11)*exp(-18.6/(.008314*TK))))" //NEW_LINE('')// &
&"    20 save rate0 * time" //NEW_LINE('')// &
&"-end" //NEW_LINE('')// &


! ----------------------------------%%
! DEFINE THE KIND OF OUTPUT
! ----------------------------------%%

&"DUMP" //NEW_LINE('')// &
&"    -solution 1" //NEW_LINE('')// &
&"    -equilibrium_phases" //NEW_LINE('')// &

  &"SELECTED_OUTPUT" //NEW_LINE('')// &
  &"    -reset false" //NEW_LINE('')// &
  &"    -high_precision true" //NEW_LINE('')// &
  &"    -k plagioclase augite pigeonite magnetite bglass" //NEW_LINE('')// &
  &"    -ph" //NEW_LINE('')// &
  &"    -molalities Ca+2 Mg+2 Na+ K+ Fe+3 SO4-2 SiO2 Cl- Al+3 HCO3-" //NEW_LINE('')// &
  &"    -totals C" //NEW_LINE('')// &
  &"    -alkalinity" //NEW_LINE('')// &
!  &"    -molalities HCO3-" //NEW_LINE('')// &
  &"    -p stilbite sio2(am) kaolinite albite saponite-mg celadonite Clinoptilolite-Ca" //NEW_LINE('')// &
  &"    -p pyrite Montmor-Na goethite dolomite Smectite-high-Fe-Mg Dawsonite" //NEW_LINE('')// &
  &"    -p magnesite siderite calcite quartz k-feldspar" //NEW_LINE('')// &
  &"    -p saponite-na Nontronite-Na Nontronite-Mg Nontronite-K Nontronite-H " //NEW_LINE('')// &
  &"    -p Nontronite-Ca muscovite mesolite hematite diaspore" //NEW_LINE('')// &
  &"    -calculate_values R(phi) R(s_sp) R(water_volume) R(rho_s)" //NEW_LINE('')// &
  &"    -time" //NEW_LINE('')// &
  &"END"
  
  
! INITIALIZE STUFF
id = CreateIPhreeqc()
IF (id.LT.0) THEN
	STOP
END IF

IF (SetSelectedOutputStringOn(id, .TRUE.).NE.IPQ_OK) THEN
	CALL OutputErrorString(id)
	STOP
END IF

IF (SetOutputStringOn(id, .TRUE.).NE.IPQ_OK) THEN
	CALL OutputErrorString(id)
	STOP
END IF
  
IF (LoadDatabase(id, "llnl.dat").NE.0) THEN
	CALL OutputErrorString(id)
	STOP
END IF

! RUN INPUT
IF (RunString(id, inputz0).NE.0) THEN
	CALL OutputErrorString(id)
	STOP
END IF
  
! PRINT DUMP/OUTPUT
DO i=1,GetOutputStringLineCount(id)
	call GetOutputStringLine(id, i, line)
	!write(*,*) trim(line)
END DO
  
! NOW KINDA USELESS PRINT STATEMENTS FOR WRITING TO FILES
!WRITE(*,*) "WRITING TO 2D ARRAY AND OUTPUT FILES"
!WRITE(*,*) "NUMBER OF LINES:"
!WRITE(*,*) GetSelectedOutputStringLineCount(id)
! OPEN FILE (don't need no file) (USEFUL)
!OPEN(UNIT=12, FILE="testMat.txt", ACTION="write", STATUS="replace") 
  
! WRITE AWAY
!allocate(outmat(GetSelectedOutputStringLineCount(id)+1,all))
DO i=1,GetSelectedOutputStringLineCount(id)
	call GetSelectedOutputStringLine(id, i, line)
	! HEADER BITS YOU MAY WANT
	if ((i .eq. 1) .and. (j .eq. 1)) then
 	   !write(12,*) trim(line)
	   write(*,*) trim(line) ! PRINT LABELS FOR EVERY FIELD (USEFUL)
	end if
	! MEAT
	if (i .gt. 1) then
		!write(*,*) trim(line)
		!write(*,*) "line:", i
		!write(*,*) "timestep:", its0*j+i-its0-1
		outmat(its0*j+i-its0-1,1) = its0*j+i-its0-1
		read(line,*) outmat(its0*j+i-its0-1,2:)
	end if
END DO
! DESTROY INSTANCE
IF (DestroyIPhreeqc(id).NE.IPQ_OK) THEN
	STOP
END IF

jj = its0*j

write(*,*) "TIMESTEP:", jj
!write(*,*) primary
!write(*,*) secondary
!write(*,*) solute

! PUT IN VALUES FOR THE NEXT TIMESTEP
primary(1) = outmat(jj,72) ! feldspar
primary(2) = outmat(jj,74) ! augite
primary(3) = outmat(jj,76) ! pigeonite
primary(4) = outmat(jj,78) ! magnetite
primary(5) = outmat(jj,80) ! basaltic glass
secondary(1) = outmat(jj,44)
secondary(2) = outmat(jj,20)
secondary(3) = outmat(jj,34)
secondary(4) = outmat(jj,36)
secondary(5) = outmat(jj,26)
secondary(6) = outmat(jj,18)
secondary(7) = outmat(jj,22)
secondary(8) = outmat(jj,46)
secondary(9) = outmat(jj,32)
secondary(10) = outmat(jj,38)
secondary(11) = outmat(jj,24)
secondary(12) = outmat(jj,16)
secondary(13) = outmat(jj,40)
secondary(14) = outmat(jj,42)
secondary(15) = outmat(jj,28)
secondary(16) = outmat(jj,30)
secondary(17) = outmat(jj,48)
secondary(18) = outmat(jj,50)
secondary(19) = outmat(jj,52)
secondary(20) = outmat(jj,54)
secondary(21) = outmat(jj,56)
secondary(22) = outmat(jj,58)
secondary(23) = outmat(jj,60)
secondary(24) = outmat(jj,62)
secondary(25) = outmat(jj,64)
secondary(26) = outmat(jj,66)
secondary(27) = outmat(jj,68)
secondary(28) = outmat(jj,70)
solute(1) = -log10(mix1*10.0**(-outmat(jj,3)) + mix2*10.0**(-solute0(1)))
solute(2) = outmat(jj,6)*mix1 + solute0(2)*mix2
solute(3) = outmat(jj,7)*mix1 + solute0(3)*mix2
solute(4) = outmat(jj,8)*mix1 + solute0(4)*mix2
solute(5) = outmat(jj,9)*mix1 + solute0(5)*mix2
solute(6) = outmat(jj,10)*mix1 + solute0(6)*mix2
solute(7) = outmat(jj,11)*mix1 + solute0(7)*mix2
solute(8) = outmat(jj,12)*mix1 + solute0(8)*mix2
solute(9) = outmat(jj,13)*mix1 + solute0(9)*mix2
solute(10) = outmat(jj,14)*mix1 + solute0(10)*mix2
solute(11) = outmat(jj,4)*mix1 + solute0(11)*mix2
solute(12) = (outmat(jj,5))*mix1 + solute0(12)*mix2

water = outmat(jj,84) 

! SOLUTES TO STRINGS
write(s_ph,'(F25.10)') solute(1)
write(s_ca,'(F25.10)') solute(2)
write(s_mg,'(F25.10)') solute(3)
write(s_na,'(F25.10)') solute(4)
write(s_k,'(F25.10)') solute(5)
write(s_fe,'(F25.10)') solute(6)
write(s_s,'(F25.10)') solute(7)
write(s_si,'(F25.10)') solute(8)
write(s_cl,'(F25.10)') solute(9)
write(s_al,'(F25.10)') solute(10)
write(s_alk,'(F25.10)') solute(11)
write(s_co2,'(F25.10)') solute(12)
write(s_hco3,'(F25.10)') solute(13)
write(s_co3,'(F25.10)') solute(14)
write(s_water,'(F25.10)') water


! PRIMARIES TO STRINGS
write(s_feldspar,'(F25.10)') primary(1)
write(s_augite,'(F25.10)') primary(2)
write(s_pigeonite,'(F25.10)') primary(3)
write(s_magnetite,'(F25.10)') primary(4)
write(s_glass,'(F25.10)') primary(5)

! SECONDARIES TO STRINGS
write(s_siderite,'(F25.10)') secondary(1)
write(s_kaolinite,'(F25.10)') secondary(2)
write(s_goethite,'(F25.10)') secondary(3)
write(s_dolomite,'(F25.10)') secondary(4)
write(s_celadonite,'(F25.10)') secondary(5)
write(s_sio2,'(F25.10)') secondary(6)
write(s_albite,'(F25.10)') secondary(7)
write(s_calcite,'(F25.10)') secondary(8)
write(s_mont_na,'(F25.10)') secondary(9)
write(s_smectite,'(F25.10)') secondary(10)
write(s_saponite,'(F25.10)') secondary(11)
write(s_stilbite,'(F25.10)') secondary(12)
write(s_dawsonite,'(F25.10)') secondary(13)
write(s_magnesite,'(F25.10)') secondary(14)
write(s_clinoptilolite,'(F25.10)') secondary(15)
write(s_pyrite,'(F25.10)') secondary(16)
write(s_quartz,'(F25.10)') secondary(17)
write(s_kspar,'(F25.10)') secondary(18)
write(s_saponite_na,'(F25.10)') secondary(19)
write(s_nont_na,'(F25.10)') secondary(20)
write(s_nont_mg,'(F25.10)') secondary(21)
write(s_nont_k,'(F25.10)') secondary(22)
write(s_nont_h,'(F25.10)') secondary(23)
write(s_nont_ca,'(F25.10)') secondary(24)
write(s_muscovite,'(F25.10)') secondary(25)
write(s_mesolite,'(F25.10)') secondary(26)
write(s_hematite,'(F25.10)') secondary(27)
write(s_diaspore,'(F25.10)') secondary(28)

!write(*,*) s_dolomite
write(*,*) s_calcite

! END BIG LOOP
end do






!write(*,*) outmat(:,43)

! WRITE TO FILE
!OPEN(UNIT=12, FILE="r99t10_test.txt", ACTION="write", STATUS="replace") 
OPEN(UNIT=12, FILE=infile, ACTION="write", STATUS="replace") 
do i=1,its*its0
	write(12,*) outmat(i,:)
end do

! ALL DONE!
write(*,*) "this is phreeqing me out"


! secondary(:) = 0.0
! solute(1) = 7.5 ! ph
! solute(2) = 6.0e-4 ! Ca
! solute(3) = 2.0e-5 ! Mg
! solute(4) = 1.0e-3 ! Na
! solute(5) = 1.0e-4 ! K
! solute(6) = 1.2e-6 ! Fe
! solute(7) = 1.0e-4 ! S(6)
! solute(8) = 2.0e-4 ! Si
! solute(9) = 3.0e-4 ! Cl
! solute(10) = 1.0e-6 ! Al
! solute(11) = 2.0e-3 ! Alk



end program batchControl