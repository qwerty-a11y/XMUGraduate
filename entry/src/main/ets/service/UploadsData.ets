import List from "@ohos.util.List";
import * as TypeRecord from '../datatypes/Record'


export class UploadsData{
  static UploadsList:List<TypeRecord.RecordEntry>=new List<TypeRecord.RecordEntry>()
  static Filters:TypeRecord.Filter=new TypeRecord.Filter()
  static SearchText:string=""
}