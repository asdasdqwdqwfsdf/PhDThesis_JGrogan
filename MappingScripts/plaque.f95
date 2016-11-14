c	Copyright (c) 2015 James A. Grogan
c
c       Permission is hereby granted, free of charge, to any person obtaining a copy
c       of this software and associated documentation files (the "Software"), to deal
c       in the Software without restriction, including without limitation the rights
c       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
c       copies of the Software, and to permit persons to whom the Software is
c       furnished to do so, subject to the following conditions:
c
c       The above copyright notice and this permission notice shall be included in
c       call copies or substantial portions of the Software.
c
c       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
c       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
c       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
c       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
c       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
c       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
c       THE SOFTWARE.
c
c       Author: J. Grogan
c       Initial Version: 2013

	Program Plaque_Wrap
!    
!	Program to map plaque from flat to cylindrical shape.
!
	real pi,x_cor,y_cor,z_cor,theta,radius,theta_hat,rad_hat,alpha,beta,phi
    real inner_radius,outer_radius,num_folds,multiplier
    integer node_num
!	    
	open(unit=10,file='in.dat',status='old')
	open(unit=11,file='out.dat',status='unknown')
!
	tb=0.2
	A=0.5
    ecen=0.2
	t1=5.
	t2=5.
	xp1=0.5
	xp2=0.5
	rL1=11.
	rL2=8.6708
    radius=1.38
!
	do i=1, 69264
  		read(10,*)node_num,x_cor,y_cor,z_cor
		rFraction=z_cor/tb
        rindex1=(y_cor/rL1)**(-log(2.)/log(xp1))
        rbracket1=(sin(3.1415*rindex1))**t1
        rad_plaque=1.+A*rbracket1       
        rheight1=tb+(A-tb)*rbracket1
!      
		z_cor=rheight1*rFraction
!		
		xfrac=x_cor/rL2
		theta=x_cor/radius
        x_cor=(radius-rad_plaque*z_cor)*cos(theta)
        y_cor=y_cor
        z_cor=(radius-rad_plaque*z_cor)*sin(theta)+ecen*rbracket1*rFraction
     	write(11,*)node_num,',',x_cor,',',y_cor,',',z_cor
    enddo
end program
