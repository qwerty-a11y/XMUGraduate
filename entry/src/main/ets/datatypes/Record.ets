import { DateUtils } from "../utils"

export enum RecordType{
  Competition, //学业竞赛
  Innovation, //创新创业训练
  Research, //学术研究
  Honor, //荣誉称号
  SocialWork, //社会工作
  Volunteer, //志愿服务
  International, //国际组织学习
  Military //参军入伍
}

@Observed
export class TimeSpan{
  constructor(start?:number,end?:number) {
    if (start) this.start=start
    else this.start=-1
    if (end) this.end=end
    else this.end=-1
  }
  public start:number
  public end:number
  public get ToStringStart():string{
    return DateUtils._ToStringForTimeSpan(this.start)
  }
  public get ToStringEnd():string{
    return DateUtils._ToStringForTimeSpan(this.end)
  }
}

export abstract class TypeInfo{
}

export class RecordEntry{
  constructor(Type:RecordType,Title:string,Score:number,ReviewStatus:number,UploadTime:number,ModifyTime?:number) {
    this.Type=Type
    this.Title=Title
    this.Score=Score
    this.ReviewStatus=ReviewStatus
    this.UploadTime=UploadTime
    if (ModifyTime) this.ModifyTime=ModifyTime
    else this.ModifyTime=UploadTime
  }
  public Type:RecordType
  public Title:string
  public Score:number
  public ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  public UploadTime:number
  public ModifyTime:number
}

export class Filter{
  public ReviewStatus:boolean[]=[false,false,false,false]
  public EnableStatus:boolean = false
  public Type:boolean[]=[false,false,false,false,false,false,false,false]
  public EnableType:boolean = false
  public UploadTime:TimeSpan=new TimeSpan()
  public ModifyTime:TimeSpan=new TimeSpan()
  public clone():Filter{
    let NewFilter=new Filter()
    NewFilter.ReviewStatus = this.ReviewStatus.slice()
    NewFilter.EnableStatus = this.EnableStatus
    NewFilter.Type = this.Type.slice()
    NewFilter.EnableType = this.EnableType
    NewFilter.UploadTime = new TimeSpan(this.UploadTime.start,this.UploadTime.end)
    NewFilter.ModifyTime = new TimeSpan(this.ModifyTime.start, this.ModifyTime.end)
    return NewFilter
  }
}