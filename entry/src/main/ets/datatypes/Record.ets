import { DateUtils } from "../utils"
import * as TypeInfoEnums from './TypeInfoEnums'
import { JSON } from "@kit.ArkTS"

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

export abstract class TypeInfo {
  constructor() {}

  abstract toJSON(): string;
  abstract fromJSON(jsonString: string): void;
}

export class Competition extends TypeInfo {
  constructor() {
    super()
  }
  public type?: TypeInfoEnums.CompetitionTypes
  public data_general?: TypeInfoEnums.Competition_general
  public data_ccf?: TypeInfoEnums.Competition_ccf

  public get data(): TypeInfoEnums.Competition_general | TypeInfoEnums.Competition_ccf | undefined {
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.CompetitionTypes.general) return this.data_general
    if (this.type == TypeInfoEnums.CompetitionTypes.ccf) return this.data_ccf
    return undefined
  }

  toJSON(): string {
    const data = this.data;
    if (!data) {
      return '{}';
    }

    if (this.type === TypeInfoEnums.CompetitionTypes.general && this.data_general) {
      const general = this.data_general;
      let json = '{';

      // 手动处理每个字段
      if (general.competition_level) {
        let enumValue = '';
        if (general.competition_level === TypeInfoEnums.COMPETITION_LEVELS.A_PLUS) enumValue = 'A_PLUS';
        else if (general.competition_level === TypeInfoEnums.COMPETITION_LEVELS.A) enumValue = 'A';
        else if (general.competition_level === TypeInfoEnums.COMPETITION_LEVELS.A_MINUS) enumValue = 'A_MINUS';
        json += `"competition_level":"${enumValue}",`;
      }

      if (general.competition_grade) {
        let enumValue = '';
        if (general.competition_grade === TypeInfoEnums.COMPETITION_GRADES.national) enumValue = 'national';
        else if (general.competition_grade === TypeInfoEnums.COMPETITION_GRADES.provincial) enumValue = 'provincial';
        json += `"competition_grade":"${enumValue}",`;
      }

      if (general.award_level) {
        let enumValue = '';
        if (general.award_level === TypeInfoEnums.AWARD_LEVELS.first) enumValue = 'first';
        else if (general.award_level === TypeInfoEnums.AWARD_LEVELS.second) enumValue = 'second';
        else if (general.award_level === TypeInfoEnums.AWARD_LEVELS.third) enumValue = 'third';
        json += `"award_level":"${enumValue}",`;
      }

      if (general.team_number) {
        let enumValue = '';
        if (general.team_number === TypeInfoEnums.TEAM_NUMBER.under_5) enumValue = 'under_5';
        else if (general.team_number === TypeInfoEnums.TEAM_NUMBER.over_5) enumValue = 'over_5';
        json += `"team_number":"${enumValue}",`;
      }

      if (general.team_role) {
        let enumValue = '';
        if (general.team_role === TypeInfoEnums.TEAM_ROLES.captain) enumValue = 'captain';
        else if (general.team_role === TypeInfoEnums.TEAM_ROLES.member_2_3) enumValue = 'member_2_3';
        else if (general.team_role === TypeInfoEnums.TEAM_ROLES.member_4_5) enumValue = 'member_4_5';
        else if (general.team_role === TypeInfoEnums.TEAM_ROLES.individual) enumValue = 'individual';
        json += `"team_role":"${enumValue}",`;
      }

      // 移除最后一个逗号
      if (json.endsWith(',')) {
        json = json.slice(0, -1);
      }
      json += '}';
      return json;
    }
    else if (this.type === TypeInfoEnums.CompetitionTypes.ccf && this.data_ccf) {
      const ccf = this.data_ccf;
      let json = '{';

      if (ccf.ccf_ranking) {
        let enumValue = '';
        if (ccf.ccf_ranking === TypeInfoEnums.CCF_RANKINGS.percent_0_2) enumValue = 'percent_0_2';
        else if (ccf.ccf_ranking === TypeInfoEnums.CCF_RANKINGS.percent_1_5) enumValue = 'percent_1_5';
        else if (ccf.ccf_ranking === TypeInfoEnums.CCF_RANKINGS.percent_3) enumValue = 'percent_3';
        json += `"ccf_ranking":"${enumValue}"`;
      }

      json += '}';
      return json;
    }

    return '{}';
  }

  fromJSON(jsonString: string): void {
    // 手动解析JSON字符串
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let competition_level: string = '';
    let competition_grade: string = '';
    let award_level: string = '';
    let team_number: string = '';
    let team_role: string = '';
    let ccf_ranking: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'competition_level') {
        competition_level = value;
      } else if (key === 'competition_grade') {
        competition_grade = value;
      } else if (key === 'award_level') {
        award_level = value;
      } else if (key === 'team_number') {
        team_number = value;
      } else if (key === 'team_role') {
        team_role = value;
      } else if (key === 'ccf_ranking') {
        ccf_ranking = value;
      }
    }

    // 根据解析出的字段判断类型
    if (competition_level) {
      this.type = TypeInfoEnums.CompetitionTypes.general;
      this.data_general = {
        competition_level: this.parseCompetitionLevel(competition_level),
        competition_grade: this.parseCompetitionGrade(competition_grade),
        award_level: this.parseAwardLevel(award_level),
        team_number: this.parseTeamNumber(team_number),
        team_role: this.parseTeamRole(team_role)
      };
    } else if (ccf_ranking) {
      this.type = TypeInfoEnums.CompetitionTypes.ccf;
      this.data_ccf = {
        ccf_ranking: this.parseCCFRanking(ccf_ranking)
      };
    }
  }

  private parseCompetitionLevel(value: string): TypeInfoEnums.COMPETITION_LEVELS {
    if (value === 'A_PLUS') return TypeInfoEnums.COMPETITION_LEVELS.A_PLUS;
    if (value === 'A') return TypeInfoEnums.COMPETITION_LEVELS.A;
    if (value === 'A_MINUS') return TypeInfoEnums.COMPETITION_LEVELS.A_MINUS;
    return TypeInfoEnums.COMPETITION_LEVELS.A_PLUS;
  }

  private parseCompetitionGrade(value: string): TypeInfoEnums.COMPETITION_GRADES {
    if (value === 'national') return TypeInfoEnums.COMPETITION_GRADES.national;
    if (value === 'provincial') return TypeInfoEnums.COMPETITION_GRADES.provincial;
    return TypeInfoEnums.COMPETITION_GRADES.national;
  }

  private parseAwardLevel(value: string): TypeInfoEnums.AWARD_LEVELS {
    if (value === 'first') return TypeInfoEnums.AWARD_LEVELS.first;
    if (value === 'second') return TypeInfoEnums.AWARD_LEVELS.second;
    if (value === 'third') return TypeInfoEnums.AWARD_LEVELS.third;
    return TypeInfoEnums.AWARD_LEVELS.first;
  }

  private parseTeamNumber(value: string): TypeInfoEnums.TEAM_NUMBER {
    if (value === 'under_5') return TypeInfoEnums.TEAM_NUMBER.under_5;
    if (value === 'over_5') return TypeInfoEnums.TEAM_NUMBER.over_5;
    return TypeInfoEnums.TEAM_NUMBER.under_5;
  }

  private parseTeamRole(value: string): TypeInfoEnums.TEAM_ROLES {
    if (value === 'captain') return TypeInfoEnums.TEAM_ROLES.captain;
    if (value === 'member_2_3') return TypeInfoEnums.TEAM_ROLES.member_2_3;
    if (value === 'member_4_5') return TypeInfoEnums.TEAM_ROLES.member_4_5;
    if (value === 'individual') return TypeInfoEnums.TEAM_ROLES.individual;
    return TypeInfoEnums.TEAM_ROLES.captain;
  }

  private parseCCFRanking(value: string): TypeInfoEnums.CCF_RANKINGS {
    if (value === 'percent_0_2') return TypeInfoEnums.CCF_RANKINGS.percent_0_2;
    if (value === 'percent_1_5') return TypeInfoEnums.CCF_RANKINGS.percent_1_5;
    if (value === 'percent_3') return TypeInfoEnums.CCF_RANKINGS.percent_3;
    return TypeInfoEnums.CCF_RANKINGS.percent_0_2;
  }
}

export class Innovation extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.Innovation

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.innovation_level) {
      let enumValue = '';
      if (data.innovation_level === TypeInfoEnums.INNOVATION_LEVELS.national) enumValue = 'national';
      else if (data.innovation_level === TypeInfoEnums.INNOVATION_LEVELS.provincial) enumValue = 'provincial';
      else if (data.innovation_level === TypeInfoEnums.INNOVATION_LEVELS.university) enumValue = 'university';
      json += `"innovation_level":"${enumValue}",`;
    }

    if (data.innovation_role) {
      let enumValue = '';
      if (data.innovation_role === TypeInfoEnums.INNOVATION_ROLES.leader) enumValue = 'leader';
      else if (data.innovation_role === TypeInfoEnums.INNOVATION_ROLES.member) enumValue = 'member';
      json += `"innovation_role":"${enumValue}",`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let innovation_level: string = '';
    let innovation_role: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'innovation_level') {
        innovation_level = value;
      } else if (key === 'innovation_role') {
        innovation_role = value;
      }
    }

    this.data = {
      innovation_level: this.parseInnovationLevel(innovation_level),
      innovation_role: this.parseInnovationRole(innovation_role)
    };
  }

  private parseInnovationLevel(value: string): TypeInfoEnums.INNOVATION_LEVELS {
    if (value === 'national') return TypeInfoEnums.INNOVATION_LEVELS.national;
    if (value === 'provincial') return TypeInfoEnums.INNOVATION_LEVELS.provincial;
    if (value === 'university') return TypeInfoEnums.INNOVATION_LEVELS.university;
    return TypeInfoEnums.INNOVATION_LEVELS.national;
  }

  private parseInnovationRole(value: string): TypeInfoEnums.INNOVATION_ROLES {
    if (value === 'leader') return TypeInfoEnums.INNOVATION_ROLES.leader;
    if (value === 'member') return TypeInfoEnums.INNOVATION_ROLES.member;
    return TypeInfoEnums.INNOVATION_ROLES.leader;
  }
}

export class Research extends TypeInfo {
  constructor() {
    super()
  }
  public type?: TypeInfoEnums.ResearchTypes
  public data_paper?: TypeInfoEnums.Research_paper
  public data_patent?: TypeInfoEnums.Research_patent

  public get data(): TypeInfoEnums.Research_paper | TypeInfoEnums.Research_patent | undefined {
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.ResearchTypes.paper) return this.data_paper
    if (this.type == TypeInfoEnums.ResearchTypes.patent) return this.data_patent
    return undefined
  }

  toJSON(): string {
    const data = this.data;
    if (!data) {
      return '{}';
    }

    if (this.type === TypeInfoEnums.ResearchTypes.paper && this.data_paper) {
      const paper = this.data_paper;
      let json = '{';

      if (paper.paper_categorie) {
        let enumValue = '';
        if (paper.paper_categorie === TypeInfoEnums.PAPER_CATEGORIES.A) enumValue = 'A';
        else if (paper.paper_categorie === TypeInfoEnums.PAPER_CATEGORIES.B) enumValue = 'B';
        else if (paper.paper_categorie === TypeInfoEnums.PAPER_CATEGORIES.C) enumValue = 'C';
        json += `"paper_categorie":"${enumValue}",`;
      }

      if (paper.paper_author) {
        let enumValue = '';
        if (paper.paper_author === TypeInfoEnums.PAPER_AUTHORS.first_author) enumValue = 'first_author';
        else if (paper.paper_author === TypeInfoEnums.PAPER_AUTHORS.second_author) enumValue = 'second_author';
        else if (paper.paper_author === TypeInfoEnums.PAPER_AUTHORS.both_first) enumValue = 'both_first';
        else if (paper.paper_author === TypeInfoEnums.PAPER_AUTHORS.independent) enumValue = 'independent';
        json += `"paper_author":"${enumValue}",`;
      }

      // 移除最后一个逗号
      if (json.endsWith(',')) {
        json = json.slice(0, -1);
      }
      json += '}';
      return json;
    }
    else if (this.type === TypeInfoEnums.ResearchTypes.patent && this.data_patent) {
      const patent = this.data_patent;
      let json = '{';

      if (patent.patent_author_type) {
        let enumValue = '';
        if (patent.patent_author_type === TypeInfoEnums.PATENT_AUTHOR_TYPES.independent) enumValue = 'independent';
        else if (patent.patent_author_type === TypeInfoEnums.PATENT_AUTHOR_TYPES.first_author) enumValue = 'first_author';
        json += `"patent_author_type":"${enumValue}"`;
      }

      json += '}';
      return json;
    }

    return '{}';
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let paper_categorie: string = '';
    let paper_author: string = '';
    let patent_author_type: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'paper_categorie') {
        paper_categorie = value;
      } else if (key === 'paper_author') {
        paper_author = value;
      } else if (key === 'patent_author_type') {
        patent_author_type = value;
      }
    }

    if (paper_categorie) {
      this.type = TypeInfoEnums.ResearchTypes.paper;
      this.data_paper = {
        paper_categorie: this.parsePaperCategory(paper_categorie),
        paper_author: this.parsePaperAuthor(paper_author)
      };
    } else if (patent_author_type) {
      this.type = TypeInfoEnums.ResearchTypes.patent;
      this.data_patent = {
        patent_author_type: this.parsePatentAuthorType(patent_author_type)
      };
    }
  }

  private parsePaperCategory(value: string): TypeInfoEnums.PAPER_CATEGORIES {
    if (value === 'A') return TypeInfoEnums.PAPER_CATEGORIES.A;
    if (value === 'B') return TypeInfoEnums.PAPER_CATEGORIES.B;
    if (value === 'C') return TypeInfoEnums.PAPER_CATEGORIES.C;
    return TypeInfoEnums.PAPER_CATEGORIES.A;
  }

  private parsePaperAuthor(value: string): TypeInfoEnums.PAPER_AUTHORS {
    if (value === 'first_author') return TypeInfoEnums.PAPER_AUTHORS.first_author;
    if (value === 'second_author') return TypeInfoEnums.PAPER_AUTHORS.second_author;
    if (value === 'both_first') return TypeInfoEnums.PAPER_AUTHORS.both_first;
    if (value === 'independent') return TypeInfoEnums.PAPER_AUTHORS.independent;
    return TypeInfoEnums.PAPER_AUTHORS.first_author;
  }

  private parsePatentAuthorType(value: string): TypeInfoEnums.PATENT_AUTHOR_TYPES {
    if (value === 'independent') return TypeInfoEnums.PATENT_AUTHOR_TYPES.independent;
    if (value === 'first_author') return TypeInfoEnums.PATENT_AUTHOR_TYPES.first_author;
    return TypeInfoEnums.PATENT_AUTHOR_TYPES.independent;
  }
}

export class Honor extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.Honor

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.honor_title_level) {
      let enumValue = '';
      if (data.honor_title_level === TypeInfoEnums.HONOR_TITLE_LEVELS.national) enumValue = 'national';
      else if (data.honor_title_level === TypeInfoEnums.HONOR_TITLE_LEVELS.provincial) enumValue = 'provincial';
      else if (data.honor_title_level === TypeInfoEnums.HONOR_TITLE_LEVELS.university) enumValue = 'university';
      json += `"honor_title_level":"${enumValue}",`;
    }

    if (data.score !== undefined) {
      json += `"score":${data.score},`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let honor_title_level: string = '';
    let score: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'honor_title_level') {
        honor_title_level = value;
      } else if (key === 'score') {
        score = value;
      }
    }

    this.data = {
      honor_title_level: this.parseHonorTitleLevel(honor_title_level),
      score: parseInt(score) || 0
    };
  }

  private parseHonorTitleLevel(value: string): TypeInfoEnums.HONOR_TITLE_LEVELS {
    if (value === 'national') return TypeInfoEnums.HONOR_TITLE_LEVELS.national;
    if (value === 'provincial') return TypeInfoEnums.HONOR_TITLE_LEVELS.provincial;
    if (value === 'university') return TypeInfoEnums.HONOR_TITLE_LEVELS.university;
    return TypeInfoEnums.HONOR_TITLE_LEVELS.national;
  }
}

export class SocialWork extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.SocialWork

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.social_title !== undefined) {
      json += `"social_title":"${data.social_title}",`;
    }

    if (data.score !== undefined) {
      json += `"score":${data.score},`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let social_title: string = '';
    let score: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'social_title') {
        social_title = value;
      } else if (key === 'score') {
        score = value;
      }
    }

    this.data = {
      social_title: social_title,
      score: parseInt(score) || 0
    };
  }
}

export class Volunteer extends TypeInfo {
  constructor() {
    super()
  }
  public type?: TypeInfoEnums.VolunteerTypes
  public data_service?: TypeInfoEnums.Volunteer_service
  public data_award?: TypeInfoEnums.Volunteer_award

  public get data(): TypeInfoEnums.Volunteer_service | TypeInfoEnums.Volunteer_award | undefined {
    if (!this.type) return undefined
    if (this.type == TypeInfoEnums.VolunteerTypes.service) return this.data_service
    if (this.type == TypeInfoEnums.VolunteerTypes.award) return this.data_award
    return undefined
  }

  toJSON(): string {
    const data = this.data;
    if (!data) {
      return '{}';
    }

    if (this.type === TypeInfoEnums.VolunteerTypes.service && this.data_service) {
      const service = this.data_service;
      let json = '{';

      if (service.volunteer_time !== undefined) {
        json += `"volunteer_time":[${service.volunteer_time.join(',')}],`;
      }

      if (service.score !== undefined) {
        json += `"score":${service.score},`;
      }

      // 移除最后一个逗号
      if (json.endsWith(',')) {
        json = json.slice(0, -1);
      }
      json += '}';
      return json;
    }
    else if (this.type === TypeInfoEnums.VolunteerTypes.award && this.data_award) {
      const award = this.data_award;
      let json = '{';

      if (award.volunteer_award_level) {
        let enumValue = '';
        if (award.volunteer_award_level === TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.national) enumValue = 'national';
        else if (award.volunteer_award_level === TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.provincial) enumValue = 'provincial';
        else if (award.volunteer_award_level === TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.university) enumValue = 'university';
        json += `"volunteer_award_level":"${enumValue}",`;
      }

      if (award.role) {
        let enumValue = '';
        if (award.role === TypeInfoEnums.VOLUNTEER_ROLE.leader) enumValue = 'leader';
        else if (award.role === TypeInfoEnums.VOLUNTEER_ROLE.member) enumValue = 'member';
        else if (award.role === TypeInfoEnums.VOLUNTEER_ROLE.individual) enumValue = 'individual';
        json += `"role":"${enumValue}",`;
      }

      // 移除最后一个逗号
      if (json.endsWith(',')) {
        json = json.slice(0, -1);
      }
      json += '}';
      return json;
    }

    return '{}';
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let volunteer_time: number[] = [];
    let score: string = '';
    let volunteer_award_level: string = '';
    let role: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim();
      const value = keyValue[1].trim();

      if (key === 'volunteer_time') {
        // 解析数组格式 [start,end]
        const arrayContent = value.replace(/[\[\]]/g, '');
        const times = arrayContent.split(',');
        for (let j = 0; j < times.length; j++) {
          const time = parseInt(times[j].trim());
          if (!isNaN(time)) {
            volunteer_time.push(time);
          }
        }
      } else if (key === 'score') {
        score = value.replace(/"/g, '');
      } else if (key === 'volunteer_award_level') {
        volunteer_award_level = value.replace(/"/g, '');
      } else if (key === 'role') {
        role = value.replace(/"/g, '');
      }
    }

    if (volunteer_time.length > 0) {
      this.type = TypeInfoEnums.VolunteerTypes.service;
      this.data_service = {
        volunteer_time: volunteer_time,
        score: parseInt(score) || 0
      };
    } else if (volunteer_award_level) {
      this.type = TypeInfoEnums.VolunteerTypes.award;
      this.data_award = {
        volunteer_award_level: this.parseVolunteerAwardLevel(volunteer_award_level),
        role: this.parseVolunteerRole(role)
      };
    }
  }

  private parseVolunteerAwardLevel(value: string): TypeInfoEnums.VOLUNTEER_AWARD_LEVELS {
    if (value === 'national') return TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.national;
    if (value === 'provincial') return TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.provincial;
    if (value === 'university') return TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.university;
    return TypeInfoEnums.VOLUNTEER_AWARD_LEVELS.national;
  }

  private parseVolunteerRole(value: string): TypeInfoEnums.VOLUNTEER_ROLE {
    if (value === 'leader') return TypeInfoEnums.VOLUNTEER_ROLE.leader;
    if (value === 'member') return TypeInfoEnums.VOLUNTEER_ROLE.member;
    if (value === 'individual') return TypeInfoEnums.VOLUNTEER_ROLE.individual;
    return TypeInfoEnums.VOLUNTEER_ROLE.leader;
  }
}

export class International extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.International

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.intership_duration) {
      let enumValue = '';
      if (data.intership_duration === TypeInfoEnums.INTERNSHIP_DURATIONS.full_year) enumValue = 'full_year';
      else if (data.intership_duration === TypeInfoEnums.INTERNSHIP_DURATIONS.less_than_year) enumValue = 'less_than_year';
      json += `"intership_duration":"${enumValue}",`;
    }

    if (data.score !== undefined) {
      json += `"score":${data.score},`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let intership_duration: string = '';
    let score: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'intership_duration') {
        intership_duration = value;
      } else if (key === 'score') {
        score = value;
      }
    }

    this.data = {
      intership_duration: this.parseInternshipDuration(intership_duration),
      score: parseInt(score) || 0
    };
  }

  private parseInternshipDuration(value: string): TypeInfoEnums.INTERNSHIP_DURATIONS {
    if (value === 'full_year') return TypeInfoEnums.INTERNSHIP_DURATIONS.full_year;
    if (value === 'less_than_year') return TypeInfoEnums.INTERNSHIP_DURATIONS.less_than_year;
    return TypeInfoEnums.INTERNSHIP_DURATIONS.full_year;
  }
}

export class Military extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.Military

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.military_service_duration) {
      let enumValue = '';
      if (data.military_service_duration === TypeInfoEnums.MILITARY_SERVICE_DURATIONS.years_1_2) enumValue = 'years_1_2';
      else if (data.military_service_duration === TypeInfoEnums.MILITARY_SERVICE_DURATIONS.over_2_years) enumValue = 'over_2_years';
      json += `"military_service_duration":"${enumValue}",`;
    }

    if (data.score !== undefined) {
      json += `"score":${data.score},`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let military_service_duration: string = '';
    let score: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'military_service_duration') {
        military_service_duration = value;
      } else if (key === 'score') {
        score = value;
      }
    }

    this.data = {
      military_service_duration: this.parseMilitaryServiceDuration(military_service_duration),
      score: parseInt(score) || 0
    };
  }

  private parseMilitaryServiceDuration(value: string): TypeInfoEnums.MILITARY_SERVICE_DURATIONS {
    if (value === 'years_1_2') return TypeInfoEnums.MILITARY_SERVICE_DURATIONS.years_1_2;
    if (value === 'over_2_years') return TypeInfoEnums.MILITARY_SERVICE_DURATIONS.over_2_years;
    return TypeInfoEnums.MILITARY_SERVICE_DURATIONS.years_1_2;
  }
}

export class Sports extends TypeInfo {
  constructor() {
    super()
  }
  public data?: TypeInfoEnums.Sports

  toJSON(): string {
    if (!this.data) {
      return '{}';
    }

    const data = this.data;
    let json = '{';

    if (data.sport_competition_level) {
      let enumValue = '';
      if (data.sport_competition_level === TypeInfoEnums.SPORTS_COMPETITION_LEVELS.international) enumValue = 'international';
      else if (data.sport_competition_level === TypeInfoEnums.SPORTS_COMPETITION_LEVELS.national) enumValue = 'national';
      json += `"sport_competition_level":"${enumValue}",`;
    }

    if (data.sport_rank) {
      let enumValue = '';
      if (data.sport_rank === TypeInfoEnums.SPORTS_RANKS.champion) enumValue = 'champion';
      else if (data.sport_rank === TypeInfoEnums.SPORTS_RANKS.runner_up) enumValue = 'runner_up';
      else if (data.sport_rank === TypeInfoEnums.SPORTS_RANKS.third_place) enumValue = 'third_place';
      json += `"sport_rank":"${enumValue}",`;
    }

    if (data.sport_type) {
      let enumValue = '';
      if (data.sport_type === TypeInfoEnums.SPORTS_TYPES.team) enumValue = 'team';
      else if (data.sport_type === TypeInfoEnums.SPORTS_TYPES.individual) enumValue = 'individual';
      json += `"sport_type":"${enumValue}",`;
    }

    // 移除最后一个逗号
    if (json.endsWith(',')) {
      json = json.slice(0, -1);
    }
    json += '}';
    return json;
  }

  fromJSON(jsonString: string): void {
    const trimmed = jsonString.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return;
    }

    const content = trimmed.substring(1, trimmed.length - 1);
    const pairs = content.split(',');

    let sport_competition_level: string = '';
    let sport_rank: string = '';
    let sport_type: string = '';

    for (let i = 0; i < pairs.length; i++) {
      const pair = pairs[i];
      const keyValue = pair.split(':');
      const key = keyValue[0].trim().replace(/"/g, '');
      const value = keyValue[1].trim().replace(/"/g, '');

      if (key === 'sport_competition_level') {
        sport_competition_level = value;
      } else if (key === 'sport_rank') {
        sport_rank = value;
      } else if (key === 'sport_type') {
        sport_type = value;
      }
    }

    this.data = {
      sport_competition_level: this.parseSportCompetitionLevel(sport_competition_level),
      sport_rank: this.parseSportRank(sport_rank),
      sport_type: this.parseSportType(sport_type)
    };
  }

  private parseSportCompetitionLevel(value: string): TypeInfoEnums.SPORTS_COMPETITION_LEVELS {
    if (value === 'international') return TypeInfoEnums.SPORTS_COMPETITION_LEVELS.international;
    if (value === 'national') return TypeInfoEnums.SPORTS_COMPETITION_LEVELS.national;
    return TypeInfoEnums.SPORTS_COMPETITION_LEVELS.international;
  }

  private parseSportRank(value: string): TypeInfoEnums.SPORTS_RANKS {
    if (value === 'champion') return TypeInfoEnums.SPORTS_RANKS.champion;
    if (value === 'runner_up') return TypeInfoEnums.SPORTS_RANKS.runner_up;
    if (value === 'third_place') return TypeInfoEnums.SPORTS_RANKS.third_place;
    return TypeInfoEnums.SPORTS_RANKS.champion;
  }

  private parseSportType(value: string): TypeInfoEnums.SPORTS_TYPES {
    if (value === 'team') return TypeInfoEnums.SPORTS_TYPES.team;
    if (value === 'individual') return TypeInfoEnums.SPORTS_TYPES.individual;
    return TypeInfoEnums.SPORTS_TYPES.team;
  }
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
  public Attachments:Attachment[]=[]
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