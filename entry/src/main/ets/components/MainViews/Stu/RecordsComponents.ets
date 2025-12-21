import * as TypeInfoEnums from "../../../datatypes/TypeInfoEnums"
import * as RecordType from "../../../datatypes/Record"
import { faceDetector } from "@kit.CoreVisionKit"
import { DateUtils } from "../../../utils"
import {TimeSpanDialog} from './TimeSpanDialog'

@Component
export struct Competition{
  @Link tmpentry:RecordType.RecordEntry
  @State SelectedType:TypeInfoEnums.CompetitionTypes = TypeInfoEnums.CompetitionTypes.general
  @State TypeMenu:boolean = false
  @State GENERAL_CompetitionLevelsMENU:boolean = false
  @State GENERAL_CompetitionGradesMENU:boolean = false
  @State GENERAL_AwardLevelsMENU:boolean = false
  @State GENERAL_TeamNumberMENU:boolean = false
  @State GENERAL_TeamRoleMENU:boolean = false
  @State CCF_CCFRankingsMENU:boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Competition()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Competition
    }
    if (!object.type || !object.data_general && !object.data_ccf) {
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
      this.SelectedType=(this.tmpentry.extra_data! as RecordType.Competition).type!
    }
  }

  @Builder Type(){
    Column() {
      ForEach(TypeInfoEnums.COMPETITION_TYPES_ARRAY, (option: TypeInfoEnums.CompetitionTypes) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).type = option
            this.SelectedType = option
            this.TypeMenu = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL_CompetitionLevels(){
    Column() {
      ForEach(TypeInfoEnums.COMPETITION_LEVELS_ARRAY, (option: TypeInfoEnums.COMPETITION_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_level = option
            this.GENERAL_CompetitionLevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL_CompetitionGrades(){
    Column() {
      ForEach(TypeInfoEnums.COMPETITION_GRADES_ARRAY, (option: TypeInfoEnums.COMPETITION_GRADES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_grade = option
            this.GENERAL_CompetitionGradesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL_AwardLevels(){
    Column() {
      ForEach(TypeInfoEnums.AWARD_LEVELS_ARRAY, (option: TypeInfoEnums.AWARD_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_general!.award_level = option
            this.GENERAL_AwardLevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL_TeamNumber(){
    Column() {
      ForEach(TypeInfoEnums.TEAM_NUMBER_ARRAY, (option: TypeInfoEnums.TEAM_NUMBER) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_number = option
            this.GENERAL_TeamNumberMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL_TeamRole(){
    Column() {
      ForEach(TypeInfoEnums.TEAM_ROLES_ARRAY, (option: TypeInfoEnums.TEAM_ROLES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_role = option
            this.GENERAL_TeamRoleMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder CCF_CCFRankings(){
    Column() {
      ForEach(TypeInfoEnums.CCF_RANKINGS_ARRAY, (option: TypeInfoEnums.CCF_RANKINGS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Competition).data_ccf!.ccf_ranking = option
            this.CCF_CCFRankingsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder GENERAL(){
    Column({space:10}){
      Row(){
        Text('竞赛级别')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.GENERAL_CompetitionLevelsMENU = !this.GENERAL_CompetitionLevelsMENU
            }
          })
          .bindMenu(this.GENERAL_CompetitionLevelsMENU,this.GENERAL_CompetitionLevels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('竞赛等级')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_general!.competition_grade.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.GENERAL_CompetitionGradesMENU = !this.GENERAL_CompetitionGradesMENU
            }
          })
          .bindMenu(this.GENERAL_CompetitionGradesMENU,this.GENERAL_CompetitionGrades)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('奖项等级')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_general!.award_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.GENERAL_AwardLevelsMENU = !this.GENERAL_AwardLevelsMENU
            }
          })
          .bindMenu(this.GENERAL_AwardLevelsMENU,this.GENERAL_AwardLevels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('团队规模')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_number.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.GENERAL_TeamNumberMENU = !this.GENERAL_TeamNumberMENU
            }
          })
          .bindMenu(this.GENERAL_TeamNumberMENU,this.GENERAL_TeamNumber)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row(){
        Text('团队角色')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_general!.team_role.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.GENERAL_TeamRoleMENU = !this.GENERAL_TeamRoleMENU
            }
          })
          .bindMenu(this.GENERAL_TeamRoleMENU,this.GENERAL_TeamRole)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data! as RecordType.Competition).data_ccf!.ccf_ranking.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.CCF_CCFRankingsMENU = !this.CCF_CCFRankingsMENU
            }
          })
          .bindMenu(this.CCF_CCFRankingsMENU,this.CCF_CCFRankings)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data as RecordType.Competition).type!.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.TypeMenu = !this.TypeMenu
            }
          })
          .bindMenu(this.TypeMenu,this.Type)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
    .margin({left:16,right:16})
  }
}

@Component
export struct Innovation {
  @Link tmpentry: RecordType.RecordEntry
  @State INNOVATION_LevelsMENU: boolean = false
  @State INNOVATION_RolesMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Innovation()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Innovation
    }
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

  @Builder INNOVATION_Levels() {
    Column() {
      ForEach(TypeInfoEnums.INNOVATION_LEVELS_ARRAY, (option: TypeInfoEnums.INNOVATION_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_level = option
            this.INNOVATION_LevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder INNOVATION_Roles() {
    Column() {
      ForEach(TypeInfoEnums.INNOVATION_ROLES_ARRAY, (option: TypeInfoEnums.INNOVATION_ROLES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_role = option
            this.INNOVATION_RolesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('创新训练级别')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.INNOVATION_LevelsMENU = !this.INNOVATION_LevelsMENU
            }
          })
          .bindMenu(this.INNOVATION_LevelsMENU, this.INNOVATION_Levels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('创新训练角色')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Innovation).data!.innovation_role.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.INNOVATION_RolesMENU = !this.INNOVATION_RolesMENU
            }
          })
          .bindMenu(this.INNOVATION_RolesMENU, this.INNOVATION_Roles)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}

@Component
export struct Research {
  @Link tmpentry: RecordType.RecordEntry
  @State SelectedType: TypeInfoEnums.ResearchTypes = TypeInfoEnums.ResearchTypes.paper
  @State TypeMenu: boolean = false
  @State PAPER_CategoriesMENU: boolean = false
  @State PAPER_AuthorsMENU: boolean = false
  @State PATENT_AuthorTypesMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Research()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Research
    }
    if (!object.type || !object.data_paper && !object.data_patent) {
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
      this.SelectedType=(this.tmpentry.extra_data! as RecordType.Research).type!
    }
  }

  @Builder Type() {
    Column() {
      ForEach(TypeInfoEnums.RESEARCH_TYPES_ARRAY, (option: TypeInfoEnums.ResearchTypes) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Research).type = option
            this.SelectedType = option
            this.TypeMenu = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder PAPER_Categories() {
    Column() {
      ForEach(TypeInfoEnums.PAPER_CATEGORIES_ARRAY, (option: TypeInfoEnums.PAPER_CATEGORIES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_categorie = option
            this.PAPER_CategoriesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder PAPER_Authors() {
    Column() {
      ForEach(TypeInfoEnums.PAPER_AUTHORS_ARRAY, (option: TypeInfoEnums.PAPER_AUTHORS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_author = option
            this.PAPER_AuthorsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder PATENT_AuthorTypes() {
    Column() {
      ForEach(TypeInfoEnums.PATENT_AUTHOR_TYPES_ARRAY, (option: TypeInfoEnums.PATENT_AUTHOR_TYPES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Research).data_patent!.patent_author_type = option
            this.PATENT_AuthorTypesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder PAPER() {
    Column({ space: 10 }) {
      Row() {
        Text('论文类别')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_categorie.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.PAPER_CategoriesMENU = !this.PAPER_CategoriesMENU
            }
          })
          .bindMenu(this.PAPER_CategoriesMENU, this.PAPER_Categories)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('论文作者')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Research).data_paper!.paper_author.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.PAPER_AuthorsMENU = !this.PAPER_AuthorsMENU
            }
          })
          .bindMenu(this.PAPER_AuthorsMENU, this.PAPER_Authors)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data! as RecordType.Research).data_patent!.patent_author_type.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.PATENT_AuthorTypesMENU = !this.PATENT_AuthorTypesMENU
            }
          })
          .bindMenu(this.PATENT_AuthorTypesMENU, this.PATENT_AuthorTypes)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data as RecordType.Research).type!.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.TypeMenu = !this.TypeMenu
            }
          })
          .bindMenu(this.TypeMenu, this.Type)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
    .margin({left:16,right:16})
  }
}

@Component
export struct Honor {
  @Link tmpentry: RecordType.RecordEntry
  @State HONOR_LevelsMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Honor()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Honor
    }
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

  @Builder HONOR_Levels() {
    Column() {
      ForEach(TypeInfoEnums.HONOR_TITLE_LEVELS_ARRAY, (option: TypeInfoEnums.HONOR_TITLE_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Honor).data!.honor_title_level = option
            this.HONOR_LevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('荣誉称号级别')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Honor).data!.honor_title_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.HONOR_LevelsMENU = !this.HONOR_LevelsMENU
            }
          })
          .bindMenu(this.HONOR_LevelsMENU, this.HONOR_Levels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('申请分数')
          .fontSize(14)
          .fontColor('#666666')
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.Honor).data!.score.toString() })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              let numValue = parseInt(value)
              if (!isNaN(numValue)) {
                (this.tmpentry.extra_data! as RecordType.Honor).data!.score = numValue
              }
            }
          })
          .width(100)
          .backgroundColor("#0C182431")
          .type(InputType.Number)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}

@Component
export struct SocialWork {
  @Link tmpentry: RecordType.RecordEntry
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.SocialWork()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string) //此程序依赖bug运行，虽然这玩意按理来说根本不可能是字符串，但事实就是如此
    }else {
      object = this.tmpentry.extra_data as RecordType.SocialWork //此程序依赖bug运行，现在它又不是字符串了，我必须进行类型检查，他妈的鸿蒙
    }
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
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.SocialWork).data!.social_title })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              (this.tmpentry.extra_data! as RecordType.SocialWork).data!.social_title = value
            }
          })
          .width(150)
          .backgroundColor("#0C182431")
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('申请分数')
          .fontSize(14)
          .fontColor('#666666')
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.SocialWork).data!.score.toString() })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              let numValue = parseInt(value)
              if (!isNaN(numValue)) {
                (this.tmpentry.extra_data! as RecordType.SocialWork).data!.score = numValue
              }
            }
          })
          .width(100)
          .backgroundColor("#0C182431")
          .type(InputType.Number)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}

@Component
export struct Volunteer {
  @Link tmpentry: RecordType.RecordEntry
  @State SelectedType: TypeInfoEnums.VolunteerTypes = TypeInfoEnums.VolunteerTypes.service
  @State TypeMenu: boolean = false
  @State AWARD_LevelsMENU: boolean = false
  @State AWARD_RolesMENU: boolean = false
  TimeSpanDialogInstance?:CustomDialogController
  @State TimeSpan:number[] = [-1,-1]
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Volunteer()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Volunteer
    }
    if (!object.type || !object.data_service && !object.data_award) {
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
      this.SelectedType=(this.tmpentry.extra_data! as RecordType.Volunteer).type!
      this.TimeSpan = (this.tmpentry!.extra_data as RecordType.Volunteer).data_service!.volunteer_time
    }
  }

  @Builder Type() {
    Column() {
      ForEach(TypeInfoEnums.VOLUNTEER_TYPES_ARRAY, (option: TypeInfoEnums.VolunteerTypes) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Volunteer).type = option
            this.SelectedType = option
            this.TypeMenu = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder AWARD_Levels() {
    Column() {
      ForEach(TypeInfoEnums.VOLUNTEER_AWARD_LEVELS_ARRAY, (option: TypeInfoEnums.VOLUNTEER_AWARD_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.volunteer_award_level = option
            this.AWARD_LevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder AWARD_Roles() {
    Column() {
      ForEach(TypeInfoEnums.VOLUNTEER_ROLE_ARRAY, (option: TypeInfoEnums.VOLUNTEER_ROLE) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.role = option
            this.AWARD_RolesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
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
        Button() {
          Text(this.TimeSpan[0]>0?DateUtils.ToString(this.TimeSpan[0],true):'请设置')
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
        }
        .width(100)
        .backgroundColor('#CCCCCC')
        .borderRadius(50)
        .padding({
          top: 5,
          bottom: 5
        })
        .onClick(() => {
          if (!this.isReadonly) {
            this.TimeSpanDialogInstance = new CustomDialogController({
              builder: TimeSpanDialog(
                {
                  confirm: (NewTime: number) => {
                    this.TimeSpan[0] = NewTime;
                    (this.tmpentry!.extra_data as RecordType.Volunteer).data_service!.volunteer_time = this.TimeSpan
                    this.TimeSpanDialogInstance?.close()
                  },
                  cancel: () => {
                    this.TimeSpanDialogInstance?.close()
                  },
                  OldTime: this.TimeSpan[0]
                }),
              alignment: DialogAlignment.Bottom,
              autoCancel: true
            })
            this.TimeSpanDialogInstance?.open()
          }
        })
        .enabled(!this.isReadonly)

        Text('-').fontSize(16)
        Button() {
          Text(this.TimeSpan[1]>0?DateUtils.ToString(this.TimeSpan[1],true):"请设置")
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(14)
        }
        .width(100)
        .backgroundColor('#CCCCCC')
        .borderRadius(50)
        .padding({
          top: 5,
          bottom: 5
        })
        .onClick(() => {
          if (!this.isReadonly) {
            this.TimeSpanDialogInstance = new CustomDialogController({
              builder: TimeSpanDialog(
                {
                  confirm: (NewTime: number) => {
                    this.TimeSpan[1] = NewTime;
                    (this.tmpentry!.extra_data as RecordType.Volunteer).data_service!.volunteer_time = this.TimeSpan
                    this.TimeSpanDialogInstance?.close()
                  },
                  cancel: () => {
                    this.TimeSpanDialogInstance?.close()
                  },
                  OldTime: this.TimeSpan[1]
                }),
              alignment: DialogAlignment.Bottom,
              autoCancel: true
            })
            this.TimeSpanDialogInstance.open()
          }
        })
        .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      Row() {
        Text('申请分数')
          .fontSize(16)
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.Volunteer).data_service!.score.toString() })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              let numValue = parseInt(value)
              if (!isNaN(numValue)) {
                (this.tmpentry.extra_data! as RecordType.Volunteer).data_service!.score = numValue
              }
            }
          })
          .width(100)
          .backgroundColor("#0C182431")
          .type(InputType.Number)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.volunteer_award_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.AWARD_LevelsMENU = !this.AWARD_LevelsMENU
            }
          })
          .bindMenu(this.AWARD_LevelsMENU, this.AWARD_Levels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('志愿服务角色')
          .fontSize(16)
        Button((this.tmpentry.extra_data! as RecordType.Volunteer).data_award!.role.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.AWARD_RolesMENU = !this.AWARD_RolesMENU
            }
          })
          .bindMenu(this.AWARD_RolesMENU, this.AWARD_Roles)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
        Button((this.tmpentry.extra_data as RecordType.Volunteer).type!.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.TypeMenu = !this.TypeMenu
            }
          })
          .bindMenu(this.TypeMenu, this.Type)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
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
    .margin({left:16,right:16})
  }
}

@Component
export struct International {
  @Link tmpentry: RecordType.RecordEntry
  @State INTERNSHIP_DurationsMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.International()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.International
    }
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

  @Builder INTERNSHIP_Durations() {
    Column() {
      ForEach(TypeInfoEnums.INTERNSHIP_DURATIONS_ARRAY, (option: TypeInfoEnums.INTERNSHIP_DURATIONS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.International).data!.intership_duration = option
            this.INTERNSHIP_DurationsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('实习时长')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.International).data!.intership_duration.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.INTERNSHIP_DurationsMENU = !this.INTERNSHIP_DurationsMENU
            }
          })
          .bindMenu(this.INTERNSHIP_DurationsMENU, this.INTERNSHIP_Durations)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('申请分数')
          .fontSize(14)
          .fontColor('#666666')
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.International).data!.score.toString() })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              let numValue = parseInt(value)
              if (!isNaN(numValue)) {
                (this.tmpentry.extra_data! as RecordType.International).data!.score = numValue
              }
            }
          })
          .width(100)
          .backgroundColor("#0C182431")
          .type(InputType.Number)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}

@Component
export struct Military {
  @Link tmpentry: RecordType.RecordEntry
  @State MILITARY_DurationsMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Military()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Military
    }
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

  @Builder MILITARY_Durations() {
    Column() {
      ForEach(TypeInfoEnums.MILITARY_SERVICE_DURATIONS_ARRAY, (option: TypeInfoEnums.MILITARY_SERVICE_DURATIONS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Military).data!.military_service_duration = option
            this.MILITARY_DurationsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('兵役时长')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Military).data!.military_service_duration.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.MILITARY_DurationsMENU = !this.MILITARY_DurationsMENU
            }
          })
          .bindMenu(this.MILITARY_DurationsMENU, this.MILITARY_Durations)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('申请分数')
          .fontSize(14)
          .fontColor('#666666')
        TextInput({ text: (this.tmpentry.extra_data! as RecordType.Military).data!.score.toString() })
          .onChange((value: string) => {
            if (!this.isReadonly) {
              let numValue = parseInt(value)
              if (!isNaN(numValue)) {
                (this.tmpentry.extra_data! as RecordType.Military).data!.score = numValue
              }
            }
          })
          .width(100)
          .backgroundColor("#0C182431")
          .type(InputType.Number)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}

@Component
export struct Sports {
  @Link tmpentry: RecordType.RecordEntry
  @State SPORTS_LevelsMENU: boolean = false
  @State SPORTS_RanksMENU: boolean = false
  @State SPORTS_TypesMENU: boolean = false
  @Prop isReadonly: boolean = false  // 新增只读参数

  aboutToAppear(): void {
    let object = new RecordType.Sports()
    if (typeof(this.tmpentry.extra_data)==typeof("")){
      object.fromJSON(this.tmpentry.extra_data as string)
    }else {
      object = this.tmpentry.extra_data as RecordType.Sports
    }
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

  @Builder SPORTS_Levels() {
    Column() {
      ForEach(TypeInfoEnums.SPORTS_COMPETITION_LEVELS_ARRAY, (option: TypeInfoEnums.SPORTS_COMPETITION_LEVELS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Sports).data!.sport_competition_level = option
            this.SPORTS_LevelsMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder SPORTS_Ranks() {
    Column() {
      ForEach(TypeInfoEnums.SPORTS_RANKS_ARRAY, (option: TypeInfoEnums.SPORTS_RANKS) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Sports).data!.sport_rank = option
            this.SPORTS_RanksMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  @Builder SPORTS_Types() {
    Column() {
      ForEach(TypeInfoEnums.SPORTS_TYPES_ARRAY, (option: TypeInfoEnums.SPORTS_TYPES) => {
        Text(option)
          .width('100%')
          .padding(10)
          .onClick(() => {
            (this.tmpentry.extra_data! as RecordType.Sports).data!.sport_type = option
            this.SPORTS_TypesMENU = false
          })
      })
    }
    .backgroundColor(Color.White)
    .width('40%')
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Text('比赛级别')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_competition_level.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.SPORTS_LevelsMENU = !this.SPORTS_LevelsMENU
            }
          })
          .bindMenu(this.SPORTS_LevelsMENU, this.SPORTS_Levels)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('比赛名次')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_rank.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.SPORTS_RanksMENU = !this.SPORTS_RanksMENU
            }
          })
          .bindMenu(this.SPORTS_RanksMENU, this.SPORTS_Ranks)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text('比赛类型')
          .fontSize(14)
          .fontColor('#666666')
        Button((this.tmpentry.extra_data! as RecordType.Sports).data!.sport_type.valueOf())
          .onClick(() => {
            if (!this.isReadonly) {
              this.SPORTS_TypesMENU = !this.SPORTS_TypesMENU
            }
          })
          .bindMenu(this.SPORTS_TypesMENU, this.SPORTS_Types)
          .width(100)
          .backgroundColor("#0C182431")
          .fontColor(Color.Black)
          .enabled(!this.isReadonly)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('90%')
    .margin({left:16,right:16})
  }
}