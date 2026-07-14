       DEF  START_FRESH_UNDO_ENTRY
       DEF  RESERVE_UNDO_SPACE
*
       REF  UNDLST
* Mem Buffer library
       REF  ARYALC,ARYINS,ARYDEL,ARYADR
       REF  ARYADD
       REF  BUFALC,BUFREE,BUFCPY,BUFGRW
       REF  BUFSRK

* variables just for INPUT
       REF  UNDOIDX,UNDO_ADDRESS,PREV_ACTION
       REF  CHRPAX,PARINX

       COPY 'EQUVAL.asm'
       COPY 'EQUADDR.asm'

*
* Increment UNDO index and create a new undo object
* without validating that it is necessary.
*
* Input:
*  R2 - undo type
* Output:
*  R0 - address of new undo object
*  R1 - address of new element in undo list
*
START_FRESH_UNDO_ENTRY
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R3,*R10
* Increment undo index.
       INC  @UNDOIDX
REMOVE_UNDO_ACTION_LOOP
* Is there already an old undo action at current index?
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R3
       C    *R0,R3
       JLE  ADD_UNDO_LIST_ELEM
* Yes, deallocate old undo action from memory
       BL   @DELETE_ONE_UNDO_ELEMENT
       JMP  REMOVE_UNDO_ACTION_LOOP
*
ADD_UNDO_LIST_ELEM
* Has undo list reached maximum length?
       CI   R3,MAX_UNDO_LIST_LENGTH
       JL   UNDO_LIST_LENGTH_OKAY
* Yes, deallocate the oldest undo-object
       CLR  R3
       BL   @DELETE_ONE_UNDO_ELEMENT
* Decrease the undo index since the list is shorter
       DEC  @UNDOIDX
UNDO_LIST_LENGTH_OKAY
* Add new element at end of undo list
* Let R1 = address of element in undo list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADD
       JEQ  MEMORY_ERROR
       MOV  R0,@UNDLST
* Create undo action and store its location in the undo list
       LI   R0,UNDO_PAYLOAD
       BLWP @BUFALC
       JEQ  MEMORY_ERROR
!      MOV  R0,*R1
* Store address of undo action longer-term
       MOV  R0,@UNDO_ADDRESS
* Populate undo action
       MOV  R2,*R0+                * type of action
       MOV  @PARINX,*R0+           * paragraph index before action
       MOV  @CHRPAX,*R0+           * character index before action
       MOV  @PARINX,*R0+           * paragraph index after action
       MOV  @CHRPAX,*R0+           * character index after action
       CLR  *R0+                   * length of undo payload
* Restore the value of R0 to point to address of undo object
       AI   R0,-UNDO_PAYLOAD
*
       MOV  *R10+,R3
       MOV  *R10+,R11
       RT

*
* Delete one element from the undo list,
* and deallocate the undo action it points to.
*
* Input:
*   R3 = index of undo element to remove
*
DELETE_ONE_UNDO_ELEMENT
* Deallocate undo action from memory
       MOV  @UNDLST,R0
       MOV  R3,R1
       BLWP @ARYADR
       MOV  *R1,R0
       BLWP @BUFREE
* Delete element from undo list
       MOV  @UNDLST,R0
       MOV  R3,R1
       BLWP @ARYDEL
*
       RT

*
* Reserve space for undo data
*
* Input:
*   R0 - number of bytes to reserve
* Output:
*   R0 - address of reserved bytes
RESERVE_UNDO_SPACE
       DECT R10
       MOV  R11,*R10
       DECT R10
       MOV  R3,*R10
       DECT R10
       MOV  R2,*R10
       DECT R10
       MOV  R0,*R10
* Let R3 = address in undo list
* Let R4 = address of undo action
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  *R1,R4
       MOV  R1,R3
* Will undo payload surpass max length?
       MOV  @UNDO_ANY_LEN(R4),R0
       A    *R10,R0
       CI   R0,MAX_UNDO_PAYLOAD
       JLE  INCREASE_ACTION_LENGTH
* Yes, create a new undo object
* Let R2 = undo type
* Let R3 = address of new element in undo list
* Let R4 = address of new action
       MOV  *R4,R2
       BL   @START_FRESH_UNDO_ENTRY
       MOV  R1,R3
       MOV  R0,R4
*
INCREASE_ACTION_LENGTH
* Increase length of undo-action
* Let R0 = new address of undo-action
       MOV  R4,R0
       LI   R1,UNDO_PAYLOAD
       A    @UNDO_ANY_LEN(R4),R1
       A    *R10,R1
       BLWP @BUFGRW
       JNE  !
* Memory error
       MOV  *R10+,R2
       MOV  *R10+,R11
       JMP  MEMORY_ERROR_2
!
* Store new address of undo-action in the undo list
       MOV  R0,R4
       MOV  R0,*R3
* Let R0 = address of reserved space
       AI   R0,UNDO_PAYLOAD
       A    @UNDO_ANY_LEN(R4),R0
* Update the length of the undo text
       A    *R10+,@UNDO_ANY_LEN(R4)
*
       MOV  *R10+,R2
       MOV  *R10+,R3
       MOV  *R10+,R11
       RT

*
* If either of the methods in this file results in a memory error.
* Set the EQ status bit to true.
*
* Call MEMORY_ERROR when the only thing to remove from the stack is a return address.
* Call MEMORY_ERROR_2 when you needed to remove more from the stack, and did that separately.
*
MEMORY_ERROR
       MOV  *R10+,R11
MEMORY_ERROR_2
       SB   R0,R0
       RT

       END