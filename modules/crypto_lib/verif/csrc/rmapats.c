// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1199, EBLK  * I1200, U  I669);
void  hsG_0__0 (struct dummyq_struct * I1199, EBLK  * I1200, U  I669)
{
    U  I1449;
    U  I1450;
    U  I1451;
    struct futq * I1452;
    I1449 = ((U )vcs_clocks) + I669;
    I1451 = I1449 & ((1 << fHashTableSize) - 1);
    I1200->I721 = (EBLK  *)(-1);
    I1200->I725 = I1449;
    if (I1449 < (U )vcs_clocks) {
        I1450 = ((U  *)&vcs_clocks)[1];
        sched_millenium(I1199, I1200, I1450 + 1, I1449);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I669 == 1)) {
        I1200->I727 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I721 = I1200;
        peblkFutQ1Tail = I1200;
    }
    else if ((I1452 = I1199->I1110[I1451].I739)) {
        I1200->I727 = (struct eblk *)I1452->I738;
        I1452->I738->I721 = (RP )I1200;
        I1452->I738 = (RmaEblk  *)I1200;
    }
    else {
        sched_hsopt(I1199, I1200, I1449);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
