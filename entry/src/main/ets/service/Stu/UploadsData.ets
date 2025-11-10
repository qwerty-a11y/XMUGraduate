import List from "@ohos.util.List";
import * as TypeRecord from '../../datatypes/Record'

@Observed
export class UploadsData{
  public static UploadsList:TypeRecord.RecordEntry[]=[]
  public static Filters:TypeRecord.Filter=new TypeRecord.Filter()
  public static FilteredList:TypeRecord.RecordEntry[]=[]
  public static SearchText:string=""
  public static Filter(){
    UploadsData.FilteredList=[]
    UploadsData.UploadsList.forEach((value)=>{
      if (
        (
          !UploadsData.Filters.EnableStatus ||
          UploadsData.Filters.ReviewStatus[value.ReviewStatus]
        ) &&
        (
          !UploadsData.Filters.EnableType ||
          UploadsData.Filters.Type[value.Type.valueOf()]
        ) &&
        (
          UploadsData.Filters.UploadTime.start < 0 ||
          UploadsData.Filters.UploadTime.start <= value.UploadTime
        ) &&
        (
          UploadsData.Filters.UploadTime.end < 0 ||
          UploadsData.Filters.UploadTime.end >= value.UploadTime
        ) &&
        (
          UploadsData.Filters.ModifyTime.start < 0 ||
          UploadsData.Filters.ModifyTime.start <= value.ModifyTime
        ) &&
        (
          UploadsData.Filters.ModifyTime.end < 0 ||
          UploadsData.Filters.ModifyTime.end >= value.ModifyTime
        ) &&
        value.Title.includes(UploadsData.SearchText))
      {
        UploadsData.FilteredList.push(value)
      }
    })
  }
}