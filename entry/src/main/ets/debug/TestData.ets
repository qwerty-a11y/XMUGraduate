import List from "@ohos.util.List";
import * as TypeRecord from '../datatypes/Record'

export class TestData{
  public static RecordList:TypeRecord.RecordEntry[]=[
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Competition,"测试标题1",1.0,0,Date.now()
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Innovation,"测试标题2",2.0,0,Date.now()-2000
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Innovation,"测试标题3",1.0,1,Date.now()-4000
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Honor,"测试标题4",2.0,1,Date.now()
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Research,"测试标题5",1.0,2,Date.now()
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.SocialWork,"测试标题6",1.0,2,Date.now()
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Innovation,"测试标题7",1.5,3,Date.now()
    ),
    new TypeRecord.RecordEntry(
      TypeRecord.RecordType.Competition,"测试标题8",2.0,3,Date.now()
    ),
  ]
}