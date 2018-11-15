      SUBROUTINE DHETR (NA,NB,NC,L,M,N,LOW,IGH,A,B,C,ORT)
      INTEGER NA,NB,NC,L,M,N,LOW,IGH
      DOUBLE PRECISION A(NA,N),B(NB,M),C(NC,N),ORT(N)
C
C     *** PURPOSE:
C
C     GIVEN A REAL GENERAL MATRIX A, DHETR REDUCES A SUBMATRIX
C     OF A IN ROWS AND COLUMNS LOW THROUGH IGH TO UPPER HESSENBERG
C     FORM BY ORTHOGONAL SIMILARITY TRANSFORMATIONS.  THESE
C     ORTHOGONAL TRANSFORMATIONS ARE FURTHER ACCUMULATED INTO ROWS
C     LOW THROUGH IGH OF AN N X M MATRIX B AND COLUMNS LOW
C     THROUGH IGH OF AN L X N MATRIX C BY PREMULTIPLICATION AND
C     POSTMULTIPLICATION, RESPECTIVELY.
C
C     THE CODE IS ADAPTED FROM THE EISPACK SUBROUTINE ORTHES
C     AND THE ORTHES DOCUMENTATION MAY BE CONSULTED FOR FURTHER
C     NUMERICAL DETAILS CONCERNING HOUSEHOLDER TRANSFORMATIONS.
C
C     ON ENTRY:
C
C        NA,NB,NC INTEGERS
C                 THE LEADING OR ROW DIMENSIONS OF THE ARRAYS
C                 A, B, AND C, RESPECTIVELY, AS DECLARED IN THE
C                 MAIN CALLING PROGRAM.
C
C        L        INTEGER
C                 NUMBER OF ROWS OF C.
C
C        M        INTEGER
C                 NUMBER OF COLUMNS OF B.
C
C        N        INTEGER
C                 ORDER OF A AND NUMBER OF ROWS OF B AND COLUMNS OF C.
C
C        LOW,IGH  INTEGERS
C                 INTEGERS DETERMINED BY THE BALANCING SUBROUTINE
C                 BALANC.  IF BALANC HAS NOT BEEN USED, SET  LOW = 1
C                 AND  IGH = N.
C
C        A        DOUBLE PRECISION(NA,N)
C                 AN N X N REAL GENERAL MATRIX TO BE REDUCED TO
C                 UPPER HESSENBERG FORM.
C
C        B        DOUBLE PRECISION(NB,M)
C                 AN N X M REAL MATRIX.
C
C        C        DOUBLE PRECISION(NC,N)
C                 AN L X N REAL MATRIX.
C
C     ON RETURN:
C
C        A        AN UPPER HESSENBERG MATRIX SIMILAR TO (VIA AN
C                 ORTHOGONAL MATRIX CONSISTING OF A SEQUENCE OF
C                 HOUSEHOLDER TRANSFORMATIONS) THE ORIGINAL MATRIX A;
C                 FURTHER INFORMATION CONCERNING THE ORTHOGONAL
C                 TRANSFORMATIONS USED IN THE REDUCTION IS CONTAINED
C                 IN THE ELEMENTS BELOW THE FIRST SUBDIAGONAL; SEE
C                 ORTHES DOCUMENTATION FOR DETAILS.
C
C        B        THE ORIGINAL B MATRIX PREMULTIPLIED BY THE
C                 TRANSPOSE OF THE ORTHOGONAL TRANSFORMATION USED TO
C                 REDUCE A.
C
C        C        THE ORIGINAL C MATRIX POSTMULTIPLIED BY THE ORTHOGONAL
C                 TRANSFORMATION USED TO REDUCE A.
C
C        ORT      DOUBLE PRECISION(N)
C                 A WORK VECTOR CONTAINING INFORMATION ABOUT THE
C                 ORTHOGONAL TRANSFORMATIONS; SEE ORTHES DOCUMENTATION
C                 FOR DETAILS.
C
C     THIS VERSION DATED JULY 1980.
C     ALAN J. LAUB, UNIVERSITY OF SOUTHERN CALIFORNIA.
C
C     SUBROUTINES AND FUNCTIONS CALLED:
C
C     NONE
C
C     INTERNAL VARIABLES:
C
      INTEGER I,II,J,JJ,K,KP1,KPN,LA
      DOUBLE PRECISION F,G,H,SCALE
C
C     FORTRAN FUNCTIONS CALLED:
C
      DOUBLE PRECISION DABS,DSIGN,DSQRT
C
      LA = IGH-1
      KP1 = LOW+1
      IF (LA .LT. KP1) GO TO 170
      DO 160 K = KP1,LA
         H = 0.0D0
         ORT(K) = 0.0D0
         SCALE = 0.0D0
C
C        SCALE COLUMN
C
         DO 10 I = K,IGH
              SCALE = SCALE+DABS(A(I,K-1))
   10    CONTINUE
         IF (SCALE .EQ. 0.0D0) GO TO 150
         KPN = K+IGH
         DO 20 II = K,IGH
              I = KPN-II
              ORT(I) = A(I,K-1)/SCALE
              H = H+ORT(I)*ORT(I)
   20    CONTINUE
         G = -DSIGN(DSQRT(H),ORT(K))
         H = H-ORT(K)*G
         ORT(K) = ORT(K)-G
C
C        FORM  (I-(U*TRANSPOSE(U))/H)*A
C
         DO 50 J = K,N
              F = 0.0D0
              DO 30 II = K,IGH
                   I = KPN-II
                   F = F+ORT(I)*A(I,J)
   30         CONTINUE
              F = F/H
              DO 40 I = K,IGH
                   A(I,J) = A(I,J)-F*ORT(I)
   40         CONTINUE
   50    CONTINUE
C
C        FORM  (I-(U*TRANSPOSE(U))/H)*B
C
         DO 80 J = 1,M
              F = 0.0D0
              DO 60 II = K,IGH
                   I = KPN-II
                   F = F+ORT(I)*B(I,J)
   60         CONTINUE
              F = F/H
              DO 70 I = K,IGH
                   B(I,J) = B(I,J)-F*ORT(I)
   70         CONTINUE
   80    CONTINUE
C
C        FORM  (I-(U*TRANSPOSE(U))/H)*A*(I-(U*TRANSPOSE(U))/H)
C
         DO 110 I = 1,IGH
              F = 0.0D0
              DO 90 JJ = K,IGH
                   J = KPN-JJ
                   F = F+ORT(J)*A(I,J)
   90         CONTINUE
              F = F/H
              DO 100 J = K,IGH
                   A(I,J) = A(I,J)-F*ORT(J)
  100         CONTINUE
  110    CONTINUE
C
C        FORM  C*(I-(U*TRANSPOSE(U))/H)
C
         DO 140 I = 1,L
              F = 0.0D0
              DO 120 JJ = K,IGH
                   J = KPN-JJ
                   F = F+ORT(J)*C(I,J)
  120         CONTINUE
              F = F/H
              DO 130 J = K,IGH
                   C(I,J) = C(I,J)-F*ORT(J)
  130         CONTINUE
  140    CONTINUE
         ORT(K) = SCALE*ORT(K)
         A(K,K-1) = SCALE*G
  150    CONTINUE
  160 CONTINUE
  170 CONTINUE
      RETURN
      END