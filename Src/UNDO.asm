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
       REF  UNDOIDX,PREV_ACTION
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
* Decrease the undo index since the list is shorter
       CLR  R3
       BL   @DELETE_ONE_UNDO_ELEMENT
       DEC  @UNDOIDX
UNDO_LIST_LENGTH_OKAY
* Add new element at end of undo list
* Let R1 = address of element in undo list
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADD
       JMP  ARRAY_GROWTH_SUCCESS
* Delete old elements until we can add a new element.
* Decrease the undo index since the list is shorter
       CLR  R3
       BL   @DELETE_ONE_UNDO_ELEMENT
       DEC  @UNDOIDX
       JEQ  START_FRESH_MEM_ERROR
       JNE  UNDO_LIST_LENGTH_OKAY
* Array grew successfully. Record new address of array.
ARRAY_GROWTH_SUCCESS
       MOV  R0,@UNDLST
* Create undo action and store its location in the undo list
ACTION_CREATION
       LI   R0,UNDO_PAYLOAD
       BLWP @BUFALC
       JMP  ALLOCATION_SUCCES
* Delete old elements until we can add a new element.
* Decrease the undo index since the list is shorter
       CLR  R3
       BL   @DELETE_ONE_UNDO_ELEMENT
       DEC  @UNDOIDX
       JEQ  START_FRESH_MEM_ERROR
       JNE  ACTION_CREATION
* Allocation of the undo action was successful. Record new address in the array.
ALLOCATION_SUCCES
       MOV  R0,R3
       MOV  @UNDLST,R0
       MOV  @UNDOIDX,R1
       BLWP @ARYADR
       MOV  R3,R0
       MOV  R0,*R1
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
* Even after deleting all elements from the undo list,
* we couldn't find memory to allocate a new element.
*
* Set the EQ bit to true, to indicate an error.
* Set both R0 and R1 to 0, so that they point to addresses in ROM.
*
START_FRESH_MEM_ERROR
       MOV  *R10+,R3
       MOV  *R10+,R11
*
       S    R0,R0
       S    R1,R1
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
* Is the undo list empty?
* If yes, report a memory allocation error.
       MOV  @UNDLST,R0
       MOV  *R0,*R0
       JEQ  RESERVE_SPACE_MEM_ERROR
* Let R3 = address in undo list
* Let R4 = address of undo action
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
       JEQ  RESERVE_SPACE_MEM_ERROR
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
* Could not increase the size of the undo payload.
* Set the EQ bit to true, to indicate an error.
* Set R0 to 0, so that it points to an address in ROM.
*
RESERVE_SPACE_MEM_ERROR
       MOV  *R10+,R0
       MOV  *R10+,R2
       MOV  *R10+,R3
       MOV  *R10+,R11
*
       S    R0,R0
       RT

       END