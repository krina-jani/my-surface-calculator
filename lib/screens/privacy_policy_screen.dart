import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Effective Date: September 21, 2026\nLast Updated: September 21, 2026',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const Divider(height: 28),

              _buildParagraph(
                'Emperor Smart Solutions ("we", "us", "our", or "Company") develops and publishes mobile applications, including utility and productivity applications available through Google Play and other supported platforms.\n\n'
                'This Privacy Policy explains how we handle information in our mobile applications.\n\n'
                'This Privacy Policy is intended to apply to our applications that link to this policy, including our utility applications such as calculators, converters, productivity tools, document utilities, and similar applications.\n\n'
                'By using one of our applications, you acknowledge the practices described in this Privacy Policy.',
              ),

              _buildSectionTitle('1. Information We Collect'),
              _buildParagraph(
                'The information handled by an application depends on the features and services used in that particular application.\n\n'
                'Information You Provide\n'
                'Our basic utility applications generally do not require users to create an account, provide their name, email address, phone number, or other personal information.\n'
                'If a particular application provides a feature that requires information to be entered or selected by the user, that information is used only for the functionality provided by that application.\n\n'
                'Information Processed Locally\n'
                'Many of our utility applications perform their primary functions directly on the user\'s device.\n'
                'For example, calculations, text counting, conversions, and similar utility functions may be performed locally without sending the entered information to our servers.\n'
                'Where an application processes files, images, documents, or text locally, such content may remain on the user\'s device unless the application specifically explains that a feature requires transmission to another service.',
              ),

              _buildSectionTitle('2. Advertising and Third-Party Services'),
              _buildParagraph(
                'Some of our applications may display advertisements provided by third-party advertising services, such as Google AdMob.\n\n'
                'Third-party advertising providers may collect or process certain information from the device, such as advertising identifiers, device information, approximate location information, diagnostic information, or information relating to advertising and app interactions, depending on the services and configuration used by the particular application.\n\n'
                'Such information may be used for purposes including:\n'
                '• Providing and displaying advertisements\n'
                '• Measuring advertising performance\n'
                '• Preventing fraud and abuse\n'
                '• Improving advertising services\n'
                '• Providing personalized or non-personalized advertising, where applicable\n\n'
                'The data practices of third-party services are governed by their respective privacy policies and applicable settings.\n'
                'We recommend that users review the privacy information provided by the relevant third-party service.',
              ),

              _buildSectionTitle('3. Analytics and Other Third-Party Services'),
              _buildParagraph(
                'Some applications may use third-party services for purposes such as:\n'
                '• Application performance monitoring\n'
                '• Crash reporting\n'
                '• Usage analytics\n'
                '• Security\n'
                '• Advertising\n'
                '• Improving application functionality\n\n'
                'The particular third-party services used may vary between applications.\n'
                'Where third-party SDKs collect or share information, the applicable data practices will be reflected in the relevant application\'s Google Play Data Safety information.',
              ),

              _buildSectionTitle('4. How We Use Information'),
              _buildParagraph(
                'Depending on the particular application and its features, information may be used to:\n'
                '• Provide and operate application features\n'
                '• Process calculations, conversions, documents, text, or other user requests\n'
                '• Improve application functionality\n'
                '• Detect and resolve technical problems\n'
                '• Monitor application performance\n'
                '• Prevent fraud, abuse, or security issues\n'
                '• Display and measure advertisements\n'
                '• Comply with applicable legal obligations\n\n'
                'We do not use information for purposes that are materially different from those described in this Privacy Policy without providing appropriate disclosure where required.',
              ),

              _buildSectionTitle('5. Data Sharing'),
              _buildParagraph(
                'We do not sell users\' personal information as part of the normal operation of our basic utility applications.\n\n'
                'Information may be processed or shared with service providers when necessary to operate specific application features or third-party services.\n\n'
                'For example, advertising, analytics, crash-reporting, hosting, security, or other technology providers may process information according to their own terms and privacy policies.\n\n'
                'The specific data practices of each application depend on the features and third-party services included in that application.',
              ),

              _buildSectionTitle('6. Data Security'),
              _buildParagraph(
                'We take reasonable measures appropriate to the nature of the information and services involved to protect information against unauthorized access, alteration, disclosure, or destruction.\n\n'
                'However, no method of electronic storage or transmission over the internet can be guaranteed to be completely secure.',
              ),

              _buildSectionTitle('7. Data Retention and Deletion'),
              _buildParagraph(
                'For utility applications that process information locally on the device, we generally do not receive or retain that locally processed information on our servers.\n\n'
                'Information handled by third-party services may be retained according to the respective service provider\'s policies and applicable legal requirements.\n\n'
                'If a particular application provides an account, cloud storage, or another feature involving server-side data, that application may have additional data retention and deletion practices applicable to that feature.\n\n'
                'Where applicable, users may contact us using the contact information below to ask questions about personal information handled by us.',
              ),

              _buildSectionTitle('8. Children\'s Privacy'),
              _buildParagraph(
                'Our applications are not intended to knowingly collect personal information from children in violation of applicable laws.\n\n'
                'If an application is specifically intended for children or directed toward children, additional privacy and data-handling requirements may apply to that application.\n\n'
                'Parents or guardians who believe that a child has provided personal information to us may contact us using the contact information provided below.',
              ),

              _buildSectionTitle('9. Permissions'),
              _buildParagraph(
                'Some applications may request Android permissions when a particular feature requires them.\n\n'
                'Permissions are requested only when necessary for the relevant functionality.\n\n'
                'The permissions requested by an application may vary depending on its features.\n\n'
                'Users can manage applicable permissions through Android device settings.',
              ),

              _buildSectionTitle('10. External Links'),
              _buildParagraph(
                'Our applications or privacy pages may contain links to external websites or social media platforms.\n\n'
                'These external services are operated independently from Emperor Smart Solutions and have their own privacy policies and terms.\n\n'
                'We are not responsible for the privacy practices of external websites or services.',
              ),

              _buildSectionTitle('11. Changes to This Privacy Policy'),
              _buildParagraph(
                'We may update this Privacy Policy from time to time to reflect changes in our applications, services, legal requirements, or privacy practices.\n\n'
                'When we make changes, we will update the Last Updated date shown at the top of this page.\n\n'
                'Users are encouraged to periodically review this Privacy Policy.',
              ),

              _buildSectionTitle('12. Contact Us'),
              _buildParagraph(
                'If you have questions, concerns, or requests regarding this Privacy Policy or our applications, you can contact us:\n\n'
                'Emperor Smart Solutions\n\n'
                'Phone:\n'
                '+91 63543 51080\n\n'
                'Instagram:\n'
                'https://www.instagram.com/emperorsmartsolutions?stkn=eng4aTNpcWZqbWE=\n\n'
                'LinkedIn:\n'
                'https://www.linkedin.com/company/emperor-smart-solutions/',
              ),

              _buildSectionTitle('13. Our Social Profiles'),
              _buildParagraph(
                'You can learn more about Emperor Smart Solutions through our official social media profiles:\n\n'
                'Instagram:\n'
                'Emperor Smart Solutions\n\n'
                'LinkedIn:\n'
                'Emperor Smart Solutions\n\n'
                'These links are provided for company information and communication purposes.',
              ),

              _buildSectionTitle('14. Application-Specific Information'),
              _buildParagraph(
                'This Privacy Policy is designed as a common policy for applications published by Emperor Smart Solutions.\n\n'
                'Because different applications may provide different features, permissions, advertising services, analytics services, or other functionality, the actual data practices of a particular application may differ.\n\n'
                'Users should also review the relevant application\'s Google Play listing and Data Safety information.\n\n'
                '© 2026 Emperor Smart Solutions. All rights reserved.',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
