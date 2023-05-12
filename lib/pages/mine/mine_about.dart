import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';

class MineAbout extends StatelessWidget {
  const MineAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '关于我们',
      body: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  width: 120,
                  height: 120,
                  image: AssetImage('assets/images/logo.png'),
                )
              ],
            ),
            const Text(
              '\t\t\t\t\t\t湖南省钜升畅安物联网科技有限公司（简称“畅安物联”）是国内致力于消防信息化研发，集消防安防、物联网产品研发、生产、销售以及服务为一体的高新技术企业。',
              style: TextStyle(height: 2.0, color: Color(0xff666666)),
            ),
            const Text(
              '\t\t\t\t\t\t畅安物联拥有完善的技术研发团队及运营、实施队伍，已形成一支由众多消防专家、安全专家、计算机及互联网领域组成的专家团队。畅安物联秉承专注创新、勇于开拓、追求卓越的精神，为消防信息化建设提供大数据沉淀，打造专业的可视化消防信息数据管理平台。',
              style: TextStyle(height: 2.0, color: Color(0xff666666)),
            )
          ]),
        )
      ],
    );
  }
}
