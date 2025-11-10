import { DateUtils } from "../utils"

export class Request{
  constructor(UploadTime:number, ID:string, Name:string, Identity:boolean, Attach:string[]) {
    this.UploadTime=UploadTime
    this.ID=ID
    this.Name=Name
    this.Identity=Identity
    this.Attach=Attach
  }
  public UploadTime:number
  public ID:string
  public Name:string
  public Identity:boolean //0=学生，1=教师
  public Attach:string[]
}