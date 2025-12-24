import * as TypeInfoEnums from "../../../datatypes/TypeInfoEnums"
import * as RecordType from "../../../datatypes/Record"
import { faceDetector } from "@kit.CoreVisionKit"
import { DateUtils } from "../../../utils"
import { Volunteer_service } from "../../../datatypes/TypeInfoEnums"

@Component
export struct Competition{
  @Link tmpentry:RecordType.RecordEntry
  @State SelectedType:TypeInfoEnums.CompetitionTypes = TypeInfoEnums.CompetitionTypes.general

  aboutToAppear(): void {
    let object = new RecordType.Competition()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.type) {
      this.tmpentry.extra_data = new RecordType.Competition();
      (this.tmpentry.extra_data as RecordType.Competition).type=TypeInfoEnums.CompetitionTypes.general;
      (this.tmpentry.extra_data as RecordType.Competition).data_general= {
        competition_level: TypeInfoEnums.COMPETITION_LEVELS.A_PLUS,
        competition_grade: TypeInfoEnums.COMPETITION_GRADES.national,
        award_level: TypeInfoEnums.AWARD_LEVELS.first,
        team_number: TypeInfoEnums.TEAM_NUMBER.under_5,
        team_role: TypeInfoEnums.TEAM_ROLES.captain
      };
      (this.tmpentry.extra_data as RecordType.Competition).data_ccf={
        ccf_ranking: TypeInfoEnums.CCF_RANKINGS.percent_0_2
      }
    }else{
      this.tmpentry.extra_data = object
    }
  }

  @Builder GENERAL(){
    Column({space:10}){
      Row(){
        Text('竞赛级别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('竞赛等级')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_grade.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('奖项等级')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_general!.award_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('团队规模')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_number.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('团队角色')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_role.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  @Builder CCF(){
    Column(){
      Row(){
        Text('CCF认证排名')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Competition).data_ccf!.ccf_ranking.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('类型')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data as RecordType.Competition).type!.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({bottom:10})
      .justifyContent(FlexAlign.SpaceBetween)
      if (this.SelectedType == TypeInfoEnums.CompetitionTypes.general){
        this.GENERAL()
      } else if (this.SelectedType == TypeInfoEnums.CompetitionTypes.ccf){
        this.CCF()
      }
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Innovation {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.Innovation()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.innovation_level) {
      this.tmpentry.extra_data = new RecordType.Innovation();
      (this.tmpentry.extra_data as RecordType.Innovation).data = {
        innovation_level: TypeInfoEnums.INNOVATION_LEVELS.national,
        innovation_role: TypeInfoEnums.INNOVATION_ROLES.leader
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('创新训练级别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('创新训练角色')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_role.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Research {
  @Link tmpentry: RecordType.RecordEntry
  @State SelectedType: TypeInfoEnums.ResearchTypes = TypeInfoEnums.ResearchTypes.paper

  aboutToAppear(): void {
    let object = new RecordType.Research()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.type) {
      this.tmpentry.extra_data = new RecordType.Research();
      (this.tmpentry.extra_data as RecordType.Research).type = TypeInfoEnums.ResearchTypes.paper;
      (this.tmpentry.extra_data as RecordType.Research).data_paper = {
        paper_categorie: TypeInfoEnums.PAPER_CATEGORIES.A,
        paper_author: TypeInfoEnums.PAPER_AUTHORS.first_author
      };
      (this.tmpentry.extra_data as RecordType.Research).data_patent = {
        patent_author_type: TypeInfoEnums.PATENT_AUTHOR_TYPES.first_author
      }
    }else{
      this.tmpentry.extra_data = object
    }
  }

  @Builder PAPER() {
    Column({ space: 10 }) {
      Row() {
        Text('论文类别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_categorie.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('论文作者')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_author.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  @Builder PATENT() {
    Column() {
      Row() {
        Text('专利作者类型')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Research).data_patent!.patent_author_type.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('类型')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data as RecordType.Research).type!.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({bottom:10})
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.SelectedType == TypeInfoEnums.ResearchTypes.paper) {
        this.PAPER()
      } else if (this.SelectedType == TypeInfoEnums.ResearchTypes.patent) {
        this.PATENT()
      }
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Honor {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.Honor()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.honor_title_level) {
      this.tmpentry.extra_data = new RecordType.Honor();
      (this.tmpentry.extra_data as RecordType.Honor).data = {
        honor_title_level: TypeInfoEnums.HONOR_TITLE_LEVELS.national,
        score: 0
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('荣誉称号级别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Honor).data!.honor_title_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('项目分数')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Honor).data!.score.toString())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct SocialWork {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.SocialWork()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.social_title) {
      this.tmpentry.extra_data = new RecordType.SocialWork();
      (this.tmpentry.extra_data as RecordType.SocialWork).data = {
        social_title: '',
        score: 0
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('社会工作职务')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.SocialWork).data!.social_title)
          .fontSize(14)
          .width(150)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('项目分数')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.SocialWork).data!.score.toString())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Volunteer {
  @Link tmpentry: RecordType.RecordEntry
  @State SelectedType: TypeInfoEnums.VolunteerTypes = TypeInfoEnums.VolunteerTypes.service

  aboutToAppear(): void {
    let object = new RecordType.Volunteer()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.type) {
      this.tmpentry.extra_data = new RecordType.Volunteer();
      (this.tmpentry.extra_data as RecordType.Volunteer).type = TypeInfoEnums.VolunteerTypes.service;
      (this.tmpentry.extra_data as RecordType.Volunteer).data_service = {
        volunteer_time: [-1, -1],
        score: 0
      };
      (this.tmpentry.extra_data as RecordType.Volunteer).data_award = {
        volunteer_award_level: TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.national,
        role: TypeInfoEnums.VOLUNTEER_ROLE.leader
      }
    }else{
      this.tmpentry.extra_data = object
    }
  }

  @Builder SERVICE() {
    Column({ space: 10 }) {
      Row() {
        Text('志愿服务时间')
          .fontSize(14)
          .fontColor('#666666')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row() {
        Text(((this.tmpentry.extra_data! as RecordType.Volunteer).data! as Volunteer_service).volunteer_time[0]>0?
        DateUtils.ToString(((this.tmpentry.extra_data! as RecordType.Volunteer).data! as Volunteer_service).volunteer_time[0],true):
          '未设置')
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.Center)

        Text('-').fontSize(14)

        Text(((this.tmpentry.extra_data! as RecordType.Volunteer).data! as Volunteer_service).volunteer_time[1]>0?
        DateUtils.ToString(((this.tmpentry.extra_data! as RecordType.Volunteer).data! as Volunteer_service).volunteer_time[1],true):
          "未设置")
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      Row() {
        Text('项目分数')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Volunteer).data_service!.score.toString())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  @Builder AWARD() {
    Column({ space: 10 }) {
      Row() {
        Text('表彰级别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.volunteer_award_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('志愿服务角色')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.role.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('类型')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data as RecordType.Volunteer).type!.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({bottom:10})
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.SelectedType == TypeInfoEnums.VolunteerTypes.service) {
        this.SERVICE()
      } else if (this.SelectedType == TypeInfoEnums.VolunteerTypes.award) {
        this.AWARD()
      }
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct International {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.International()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.intership_duration) {
      this.tmpentry.extra_data = new RecordType.International();
      (this.tmpentry.extra_data as RecordType.International).data = {
        intership_duration: TypeInfoEnums.INTERNSHIP_DURATIONS.full_year,
        score: 0
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('实习时长')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.International).data!.intership_duration.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('项目分数')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.International).data!.score.toString())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Military {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.Military()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.military_service_duration) {
      this.tmpentry.extra_data = new RecordType.Military();
      (this.tmpentry.extra_data as RecordType.Military).data = {
        military_service_duration: TypeInfoEnums.MILITARY_SERVICE_DURATIONS.years_1_2,
        score: 0
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('兵役时长')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Military).data!.military_service_duration.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('项目分数')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Military).data!.score.toString())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}

@Component
export struct Sports {
  @Link tmpentry: RecordType.RecordEntry

  aboutToAppear(): void {
    let object = new RecordType.Sports()
    object.fromJSON(this.tmpentry.extra_data as string)
    if (!object.data?.sport_competition_level) {
      this.tmpentry.extra_data = new RecordType.Sports();
      (this.tmpentry.extra_data as RecordType.Sports).data = {
        sport_competition_level: TypeInfoEnums.SPORTS_COMPETITION_LEVELS.international,
        sport_rank: TypeInfoEnums.SPORTS_RANKS.champion,
        sport_type: TypeInfoEnums.SPORTS_TYPES.individual
      };
    }else{
      this.tmpentry.extra_data = object
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('比赛级别')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_competition_level.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('比赛名次')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_rank.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('比赛类型')
          .fontSize(14)
          .fontColor('#666666')
        Text((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_type.valueOf())
          .fontSize(14)
          .width(100)
          .textAlign(TextAlign.End)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:18,right:16})
  }
}