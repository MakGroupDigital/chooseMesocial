import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'message_model.dart';
export 'message_model.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  static String routeName = 'message';
  static String routePath = 'message';

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late MessageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_ConversationItem> _conversations = [
    _ConversationItem(
      name: 'FC Barcelona Scout',
      message: 'Nous avons vu votre profil et...',
      time: '10:30',
      avatar: 'assets/images/Sans_titre-4.png',
      isOnline: true,
      unreadCount: 2,
    ),
    _ConversationItem(
      name: 'Coach Mbeki',
      message: 'Excellent match hier !',
      time: 'Hier',
      avatar: 'assets/images/Sans_titre-4.png',
      isOnline: true,
      unreadCount: 0,
    ),
    _ConversationItem(
      name: 'Real Madrid Academy',
      message: 'Votre candidature a été reçue',
      time: 'Hier',
      avatar: 'assets/images/Sans_titre-4.png',
      isOnline: false,
      unreadCount: 1,
    ),
    _ConversationItem(
      name: 'Agent Sportif Pro',
      message: 'Disponible pour un appel demain ?',
      time: 'Lun',
      avatar: 'assets/images/Sans_titre-4.png',
      isOnline: false,
      unreadCount: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF0A0A0A),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF0A0A0A)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Search bar
                _buildSearchBar(),
                
                // Online users
                _buildOnlineUsers(),
                
                // Conversations list
                Expanded(child: _buildConversationsList()),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF208050), Color(0xFF19DB8A)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF19DB8A).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.safePop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF208050), Color(0xFF19DB8A)],
            ).createShader(bounds),
            child: Text(
              'Messages',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 22),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TextField(
          controller: _model.textController,
          focusNode: _model.textFieldFocusNode,
          style: GoogleFonts.readexPro(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Rechercher une conversation...',
            hintStyle: GoogleFonts.readexPro(color: Colors.white.withOpacity(0.4)),
            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildOnlineUsers() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF19DB8A).withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0A0A0A),
                          image: DecorationImage(
                            image: AssetImage('assets/images/Sans_titre-4.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF19DB8A),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'User ${index + 1}',
                  style: GoogleFonts.readexPro(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: 100 * index))
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildConversationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conv = _conversations[index];
        return _buildConversationTile(conv, index);
      },
    );
  }

  Widget _buildConversationTile(_ConversationItem conv, int index) {
    return GestureDetector(
      onTap: () => context.pushNamed(ChatPageWidget.routeName),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: conv.isOnline 
                          ? const Color(0xFF19DB8A) 
                          : Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(conv.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (conv.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF19DB8A),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conv.name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        conv.time,
                        style: GoogleFonts.readexPro(
                          color: conv.unreadCount > 0 
                              ? const Color(0xFF19DB8A) 
                              : Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.readexPro(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (conv.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF208050), Color(0xFF19DB8A)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${conv.unreadCount}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1);
  }
}

class _ConversationItem {
  final String name;
  final String message;
  final String time;
  final String avatar;
  final bool isOnline;
  final int unreadCount;

  _ConversationItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    required this.isOnline,
    required this.unreadCount,
  });
}
