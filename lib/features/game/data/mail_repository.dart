import 'package:war_mail_atk_def/features/game/models/mail_models.dart';

class MailRepository {
  const MailRepository();

  List<MailThread> inbox() {
    return [
      MailThread(
        id: '1',
        subject: 'サンプル戦果報告: 返信されました！',
        sender: '棕櫚 名跡',
        preview: '受信欄は平和です / 紳士が来たらここに並べます',
        body:
            '司令官殿\n\n前線からの報告です。昨晩の迎撃作戦は成功し、敵部隊は大きく後退しました。残敵掃討のため、返信にて追加の指示を願います。',
        category: MailCategory.trusted,
        recommendedAction: MailAction.reply,
      ),
      MailThread(
        id: '2',
        subject: '至急: 防壁補修の稟議',
        sender: '技術局 / 梓川',
        preview: '補修班の派遣には司令官の承認が必要です。',
        body:
            '現在の防壁には小規模な損傷があります。放置すると侵入リスクが高まります。アーカイブして記録を残し、後ほど対応の順番を決めましょう。',
        category: MailCategory.mission,
        recommendedAction: MailAction.archive,
      ),
      MailThread(
        id: '3',
        subject: '⚠️ 侵入警報: 未確認の差出人',
        sender: 'Unknown Sender',
        preview: 'あなたのアカウントは危険に晒されています。クリックして確認。',
        body:
            '注意: システムがあなたの資格情報を検出しました。下記のリンクをクリックし、守秘コードを入力してください。',
        category: MailCategory.spam,
        recommendedAction: MailAction.delete,
      ),
      MailThread(
        id: '4',
        subject: '友軍より補給品の到着予定',
        sender: '後方支援部',
        preview: '輸送船団が夕刻に到着予定です。返信で受領確認を。',
        body:
            '補給船団は予定どおり進軍中です。迎えの隊員を手配し、返信で受領の確認を行ってください。',
        category: MailCategory.trusted,
        recommendedAction: MailAction.reply,
      ),
      MailThread(
        id: '5',
        subject: '情報部: 敵スパイの疑い',
        sender: '情報部 / 砂羽',
        preview: '退避命令の可否を判断してください。',
        body:
            '新たな通信が敵の手に渡った可能性があります。証拠が集まるまで保留し、記録を残してください。',
        category: MailCategory.mission,
        recommendedAction: MailAction.archive,
      ),
      MailThread(
        id: '6',
        subject: '【広告】お得な防具アップグレード',
        sender: '外部広告ネットワーク',
        preview: '今なら半額。侵攻を跳ね返す最強の防具が手に入る！',
        body:
            '公式認定ではない防具の販売案内です。リンク先は確認されていません。即時削除してください。',
        category: MailCategory.spam,
        recommendedAction: MailAction.delete,
      ),
    ];
  }
}
