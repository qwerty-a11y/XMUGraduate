import List from "@ohos.util.List";
import * as TypeRecord from '../datatypes/Record'


export class UploadsData{
  public static UploadsList:TypeRecord.RecordEntry[]=[]
  public static Filters:TypeRecord.Filter=new TypeRecord.Filter()
  public static FilteredList:TypeRecord.RecordEntry[]=[]
  public static SearchText:string=""
  public static Filter(){
    UploadsData.FilteredList=[]
    UploadsData.UploadsList.forEach((value)=>{
      if (
        UploadsData.Filters.ReviewStatus[value.ReviewStatus] &&
        UploadsData.Filters.Type[value.Type.valueOf()] &&
        (
          UploadsData.Filters.TimeSpan.start < 0 ||
          UploadsData.Filters.TimeSpan.start <= value.ModifyTime
        ) &&
        (
          UploadsData.Filters.TimeSpan.end < 0 ||
          UploadsData.Filters.TimeSpan.end >= value.ModifyTime
        ) &&
        value.Title.includes(UploadsData.SearchText))
      {
        UploadsData.FilteredList.push(value)
      }
    })
  }
}