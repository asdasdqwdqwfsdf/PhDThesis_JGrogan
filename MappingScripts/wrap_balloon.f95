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
c       Initial Version: 2010

	Program Balloon_Wrap
!    
!	Program to map an unfolded ballon geometry onto a folded configuration (Based on Laroche Paper)
!	Input: File containing nodal coords of ballon geometry (Abaqus INP Format)
!	Output: File containing nodal coords of mapped ballon geometry (Abaqus INP Format)
!
	real pi,x_cor,y_cor,z_cor,theta,radius,theta_hat,rad_hat,alpha,beta,phi
    real inner_radius,outer_radius,num_folds,multiplier
    integer node_num
    logical outer_flap
!	    
	open(unit=10,file='in.dat',status='old')
	open(unit=11,file='out.dat',status='unknown')
!
	pi=acos(-1.)
	inner_radius=0.25
    outer_radius=0.43
    num_folds=3.
    phi=(2*pi)/num_folds
    outer_flap=.false.
!
	do i=1,  9821
  		read(10,*)node_num,x_cor,y_cor,z_cor
  		theta=(atan2(z_cor,x_cor))
        radius=sqrt(z_cor*z_cor+x_cor*x_cor)
!        
  		if(theta<0.)then
    		theta=theta+2*pi
  		endif
!
		beta=(phi/2.)*(1.+(2*radius)/(inner_radius+outer_radius))
        alpha=((outer_radius+inner_radius)/(2*radius))*beta
!
		do j=1,num_folds
        	if((theta>=(j-1)*phi).and.(theta<=(alpha+(j-1)*phi)))then
            	multiplier=j-1
                outer_flap=.true.
            elseif((theta>=(alpha+(j-1)*phi)).and.(theta<=(j*phi)))then
                multiplier=j
                outer_flap=.false.
            endif
        enddo            
!
		if(outer_flap)then
            theta_hat=(beta/alpha)*(theta-multiplier*phi)+multiplier*phi
            rad_hat=inner_radius+((outer_radius-inner_radius)/beta)*(theta_hat-multiplier*phi)
        else
          	theta_hat=((beta-phi)/(phi-alpha))*(multiplier*phi-theta)+multiplier*phi
            rad_hat=inner_radius+((outer_radius-inner_radius)/(beta-phi))*(theta_hat-multiplier*phi)
        endif
!		
     	write(11,*)node_num,',',rad_hat*cos(theta_hat),',',y_cor,',',rad_hat*sin(theta_hat)
    enddo
end program
