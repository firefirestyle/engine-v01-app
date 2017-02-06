library dynablock;

class DynaBlockCore {
  String rootID;
  List<FreeSpaceInfo> infos = [];
  int rootWidth = 0;
  int rootHeight = 0;
  bool useDebugLog;

  DynaBlockCore({this.rootWidth: 600, this.useDebugLog: true}) {
    infos.add(new FreeSpaceInfo()
      ..xs = 0
      ..y = 10
      ..xe = rootWidth);
  }

  FreeSpaceInfo addBlock(int elmW, int elmH) {
    (useDebugLog == true ? print("""\r\n\r\n## START call addBlock ${elmW} ${elmH} ##""") : null);
    //
    //
    FreeSpaceInfo info = null;
    for (int i = 0; i < infos.length; i++) {
      info = infos[i];
      var w = (info.xe - info.xs);
      if (w >= elmW) {
        (useDebugLog == true ? print("""    ## SELECT FREESPACEINFO ${info.toString()}""") : null);
        break;
      }
      info = null;
    }
    if (info == null) {
      // todo
      return null;
    }
    //
    var ret = new FreeSpaceInfo.clone(info);
    updateIndex(info.xs, info.y, info.xs + elmW, info.y + elmH);

    if (useDebugLog) {
      for (var j in infos) {
        (useDebugLog == true ? print("""    ## INDEX: ${j.toString()}""") : null);
      }
    }
    if(ret.y+elmH > rootHeight) {
      rootHeight = ret.y+elmH;
    }
    return ret;
  }

  updateIndex(int xs, int ys, int xe, int ye) {
    (useDebugLog == true ? print("""    ## CALL UPDATEINDEX ${xs}, ${ys}, ${xe}, ${ye}""") : null);

    //
    // [width]
    bool added = false;
    {
      for (int i = 0; i < infos.length; i++) {
        var info = infos[i];
        if (!(info.y <= ye)) {
          continue;
        }
        if (info.xs <= xs && xs < info.xe) {
          // add
          (useDebugLog == true ? print("""      ## UPDATEINDEX IN ${info.toString()}")}""") : null);

          if (added == false) {
            var v = new FreeSpaceInfo.fromPos(xe, ys, info.xe - xe, xs, xe);
            if (false == infos.contains(v)) {
              added = true;
              infos.add(v);
            }
          }
          {
            var base1 = new FreeSpaceInfo.clone(info);
            var base2 = new FreeSpaceInfo.clone(info);
            info.xs = info.xe = 0;
            base1.xe = xs;
            base2.xs = xe;
            if (base1.xs != base1.xe) {
              (useDebugLog == true ? print("""      ## UPDATEINDEX IN a ${base1.toString()}")}""") : null);
              if (false == infos.contains(base1)) {
                (useDebugLog == true ? print("""        ## UPDATEINDEX IN a add")}""") : null);
                infos.add(base1);
              }
            }
            if (base2.xs != base2.xe) {
              (useDebugLog == true ? print("""      ## UPDATEINDEX IN b ${base2.toString()}")}""") : null);
              if (false == infos.contains(base2)) {
                (useDebugLog == true ? print("""        ## UPDATEINDEX IN b add")}""") : null);
                infos.add(base2);
              }
            }
          }
        } else {
          (useDebugLog == true ? print("""      ## UPDATEINDEX OUT ${info.toString()}")}""") : null);
        }
      }
    }
    for (int i = 0; i < infos.length; i++) {
      var info = infos[i];
      if (info.xe <= info.xs) {
        (useDebugLog == true ? print("""      ## UPDATEINDEX DElETE ${info.toString()}")}""") : null);
        infos.remove(info);
        i--;
      }
    }
    //
    // [height] over
        {
      var head = new FreeSpaceInfo.fromPos(0, ye, rootWidth, xs, xe);
      (useDebugLog == true ? print("""      ## UPDATEINDEX START HEAD ${head.toString()}")}""") : null);
      for (int i = 0; i < infos.length; i++) {
        var info = infos[i];
//s        print("##> heigh ${info.toString()}");
        if (info.y < head.y) {
          (useDebugLog == true ? print("""        ## UPDATEINDEX NOACTION ${info.toString()}""") : null);
          continue;
        }
        (useDebugLog == true ? print("""        ## UPDATEINDEX ACTION i: ${info.toString()}""") : null);
        (useDebugLog == true ? print("""          ## UPDATEINDEX ACTION start h: ${head.toString()}""") : null);

        if (info.baseXs < head.xs && head.xe < info.baseXe) {
          head = null;
          break;
        } else if (info.baseXs <= head.xs && head.xs <= info.baseXe) {
          head.xs = info.baseXe;
        } else if (info.baseXs <= head.xe && head.xe <= info.baseXe) {
          head.xe = info.baseXs;
        } else if (head.xs <= info.baseXs && info.baseXe <= head.xe) {
          if (info.baseXs <= head.baseXs) {
            head.xs = info.baseXe;
          } else {
            head.xe = info.baseXs;
          }
        }
        (useDebugLog == true ? print("""          ## UPDATEINDEX ACTION end h: ${head.toString()}""") : null);

      }
      (useDebugLog == true ? print("""        ## UPDATEINDEX ACTION i: ${head.toString()}""") : null);

      //
      if (head != null) {
        infos.add(head);
      }
    }
    //
    // [sort] order high
        {
      infos.sort((FreeSpaceInfo a, FreeSpaceInfo b) {
        return a.y - b.y;
      });
    }
  }
}

class FreeSpaceInfo {
  int xs;
  int y;
  int xe;
  int id;
  static int idid = -1;
  int baseXs;
  int baseXe;
  FreeSpaceInfo() {
    id = idid++;
  }
  FreeSpaceInfo.clone(FreeSpaceInfo base) {
    this.xs = base.xs;
    this.y = base.y;
    this.xe = base.xe;
    this.baseXs = base.baseXs;
    this.baseXe = base.baseXe;
    id = idid++;
  }
  FreeSpaceInfo.fromPos(int x, int y, int width, this.baseXs, this.baseXe) {
    id = idid++;
    this.xs = x;
    this.xe = x + width;
    this.y = y;
  }
  String toString() {
    return """[${id}] xs:xe=${xs}px,${xe}px; ys:${y}; ${baseXs}: ${baseXe}""";
  }

  bool operator ==(FreeSpaceInfo v) {
    return (xs == v.xs) && (xe == v.xe); //&& (y == v.y);// &&(baseXs == v.baseXs) &&(baseXe == v.baseXe);
  }
}