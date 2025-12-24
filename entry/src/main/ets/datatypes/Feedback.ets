import { DateUtils } from "../utils"

export class Request{
  constructor(Status:boolean, UploadTime:number, ID:string, Name:string, Content:string, Identity:boolean) {
    this.Status=Status
    this.UploadTime=UploadTime
    this.ID=ID
    this.Name=Name
    this.Content=Content
    this.Identity=Identity
  }
  public Status:boolean
  public UploadTime:number
  public ID:string
  public Name:string
  public Content:string
  public Identity:boolean //0=学生，1=教师
}