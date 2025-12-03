import { UploadsData } from "./UploadsData"

export class BasicData{
  public static GPA:number=0
  public static score:number=0
  public static estimated_score:number=0
  public static CET:number[]=[0,0]
  public static applications:number[]=[0,0,0,0,0,0,0,0,0]
  public static departments:string=''
  public static clear(){
    BasicData.GPA=0
    BasicData.score=0
    BasicData.estimated_score=0
    BasicData.CET=[0,0]
    BasicData.applications=[0,0,0,0,0,0,0,0,0]
    BasicData.departments=''
    UploadsData.UploadsList=[]
    UploadsData.FilteredList=[]
  }
}