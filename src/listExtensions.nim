import lists

func toSinglyLinkedRing*[T](elems: openArray[T]): SinglyLinkedRing[T] =
  ## Creates a new `SinglyLinkedRing` from the members of `elems`.
  runnableExamples:
    from std/sequtils import toSeq
    let a = [1, 2, 3, 4, 5].toSinglyLinkedRing
    assert a.toSeq == [1, 2, 3, 4, 5]

  result = initSinglyLinkedRing[T]()
  for elem in elems.items:
    result.add(elem)

func toDoublyLinkedRing*[T](elems: openArray[T]): DoublyLinkedRing[T] =
  ## Creates a new `DoublyLinkedRing` from the members of `elems`.
  runnableExamples:
    from std/sequtils import toSeq
    let a = [1, 2, 3, 4, 5].toDoublyLinkedRing
    assert a.toSeq == [1, 2, 3, 4, 5]

  result = initDoublyLinkedRing[T]()
  for elem in elems.items:
    result.add(elem)

proc remove*[T](L: var SinglyLinkedRing[T], n: SinglyLinkedNode[T]): bool {.discardable.} =
  ## Removes a node `n` from `L`.
  ## Returns `true` if `n` was found in `L`.
  ## Efficiency: O(n); the ring is traversed until `n` is found.
  ## Attempting to remove an element not contained in the ring is a no-op.
  runnableExamples:
    import std/[sequtils, enumerate, sugar]
    var a = [0, 1, 2].toSinglyLinkedRing
    let n = a.head.next
    assert n.value == 1
    assert a.remove(n) == true
    assert a.toSeq == [0, 2]
    assert a.remove(n) == false
    assert a.toSeq == [0, 2]
    a.addMoved(a) # cycle: [0, 2, 0, 2, ...]
    a.remove(a.head)
    let s = collect:
      for i, ai in enumerate(a):
        if i == 4: break
        ai
    assert s == [2, 2, 2, 2]

  if n == L.head:
    L.head = n.next
    if L.tail.next == n:
      L.tail.next = L.head # restore cycle
  else:
    var first = L.head
    var prev = L.head
    while prev.next != n:
      prev = prev.next
      if prev.next == nil or prev.next == first:
        return false
    prev.next = n.next
    if L.tail == n:
      L.tail = prev # update tail if we removed the last node
  true