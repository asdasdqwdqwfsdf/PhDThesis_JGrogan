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
c       Initial Version: 2012
c	-------------------------------------------------------------------	
	  subroutine vusdfld(
     *   nblock,nstatev,nfieldv,nprops,ndir,nshr,jElem,kIntPt, 
     *   kLayer,kSecPt,stepTime,totalTime,dt,cmname,coordMp,  
     *   direct,T,charLength,props,stateOld,stateNew,field)  
c
		include 'vaba_param.inc'
c
		dimension 	jElem(nblock),stateNew(nblock,nstatev),           
     *				field(nblock,nfieldv),stateOld(nblock,nstatev), 
     *	 			charLength(nblock),rPEEQ(maxblk,1),
     *				Stress(nblock*6),jData(nblock*6),					
     *	 			eigVal(nblock,3),coordMp(nblock,3)		
c	-------------------------------------------------------------------	
c		Common blocks store element status and random number assigment.
		common active(600000)
		common rnum(600000)
		common ibcheck
		integer active	
		integer rnum
		integer ibcheck
		character*256 outdir
c
		if (ibcheck/=5)then
			call vgetoutdir(outdir,lenoutdir)
			open(unit=105,file=outdir(1:lenoutdir)//'/NBR.inc',
     *			status='old')
			do while (ioe==0)
				read(105,*,iostat=ioe)ielnum,frnum
				if(ioe==0)rnum(ielnum)=frnum
			enddo
			close(unit=105)
			ibcheck=5
		endif
		do k=1,nblock
c	-------------------------------------------------------------------	
c			Update SDVs		
			do i=1,7
				stateNew(k,i)=stateOld(k,i)
			enddo	
			stateNew(k,11)=stateOld(k,11)
c	-------------------------------------------------------------------				
c			Determine Characteristic Element Length 
			damage=stateOld(k,8)
			if(steptime<2.*dt)then
				randE=rnum(statenew(k,1))
			else
				randE=stateOld(k,9)
			endif
			activeE=stateOld(k,10)
c	-------------------------------------------------------------------			
c			Check if element is on exposed surface.
			do i=2,7
				nNum=stateNew(k,i)
				if(nNum==0.)cycle
				if(active(nNum)==1)then			
					activeE=1.	
					if(rnum(nNum)*0.94>randE)randE=rnum(nNum)*0.94
				endif						
			enddo
c	-------------------------------------------------------------------								
c			Recover Corrosion Parameters
			ukinetic=0.000025d0
c			randE=1.d0
			if(activeE>0.99d0)then
				if(totaltime>1.5d0)then
					dam_inc=(ukinetic/charlength(k))*randE*dt
					damage=damage+dam_inc
				endif
			endif
c	-------------------------------------------------------------------		
c			Remove Fully Damaged Elements
			if(damage>=0.999)then			
				damage=1.d0
				stateNew(k,11)=0.d0
				active(statenew(k,1))=1.d0
				rnum(statenew(k,1))=randE
			endif
c	-------------------------------------------------------------------		
			stateNew(k,8)=damage
			field(k,1)=damage
			stateNew(k,9)=randE
			stateNew(k,10)=activeE	
c	-------------------------------------------------------------------				
		end do		
		return 
      end subroutine vusdfld	    	  	  	 	 	  
	  
		
	 
	 
	 
	 
	 