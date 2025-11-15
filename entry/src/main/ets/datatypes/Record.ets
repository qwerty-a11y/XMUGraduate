import { DateUtils } from "../utils"
import * as TypeInfoEnums from './TypeInfoEnums'

export enum RecordType{
  Competition, //学业竞赛
  Innovation, //创新创业训练
  Research, //科研成果
  Honor, //荣誉称号
  SocialWork, //社会工作
  Volunteer, //志愿服务
  International, //国际组织学习
  Military, //参军入伍
  Sports //体育比赛
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

export class Competition extends TypeInfo{
  constructor() {
    super()
  }
  public type?:TypeInfoEnums.CompetitionTypes
  public data_general?:TypeInfoEnums.Competition_general
  public data_ccf?:TypeInfoEnums.Competition_ccf
  public get data():TypeInfoEnums.Competition_general|TypeInfoEnums.Competition_ccf|undefined{
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.CompetitionTypes.general) return this.data_general
    if (this.type == TypeInfoEnums.CompetitionTypes.ccf) return this.data_ccf
    return undefined
  }
}

export class Innovation extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.Innovation
}

export class Research extends TypeInfo{
  constructor() {
    super()
  }
  public type?:TypeInfoEnums.ResearchTypes
  public data_paper?:TypeInfoEnums.Research_paper
  public data_patent?:TypeInfoEnums.Research_patent
  public get data():TypeInfoEnums.Research_paper|TypeInfoEnums.Research_patent|undefined{
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.ResearchTypes.paper) return this.data_paper
    if (this.type == TypeInfoEnums.ResearchTypes.patent) return this.data_patent
    return undefined
  }
}

export class Honor extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.Honor
}

export class SocialWork extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.SocialWork
}

export class Volunteer extends TypeInfo{
  constructor() {
    super()
  }
  public type?:TypeInfoEnums.VolunteerTypes
  public data_service?:TypeInfoEnums.Volunteer_service
  public data_award?:TypeInfoEnums.Volunteer_award
  public get data():TypeInfoEnums.Volunteer_service|TypeInfoEnums.Volunteer_award|undefined{
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.VolunteerTypes.service) return this.data_service
    if (this.type == TypeInfoEnums.VolunteerTypes.award) return this.data_award
    return undefined
  }
}

export class International extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.International
}

export class Military extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.Military
}

export class Sports extends TypeInfo{
  constructor() {
    super()
  }
  public data?:TypeInfoEnums.Sports
}

export interface Attachment{
  id:string,
  name:string
}

export class RecordEntry{
  constructor(Type:RecordType,Title:string,Score:number,ReviewStatus:number,Description:string,UploadTime:number,ModifyTime?:number) {
    this.Type=Type
    this.Title=Title
    this.ApplyScore=Score
    this.RealScore=-1
    this.ReviewStatus=ReviewStatus
    this.UploadTime=UploadTime
    if (ModifyTime) this.ModifyTime=ModifyTime
    else this.ModifyTime=UploadTime
    this.Description=Description
  }
  public Type:RecordType
  public Title:string
  public ApplyScore:number
  public RealScore:number
  public ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  public UploadTime:number
  public ModifyTime:number
  public Description:string
  public Attachments:string[]=[]
  public FeedBack:string = ''
  public extra_data?:TypeInfo
}

export class Filter{
  public ReviewStatus:boolean[]=[false,false,false,false]
  public EnableStatus:boolean = false
  public Type:boolean[]=[false,false,false,false,false,false,false,false,false]
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