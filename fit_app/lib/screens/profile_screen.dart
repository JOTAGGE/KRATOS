import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/user_profile_model.dart';
import '../services/profile_service.dart';
import '../services/image_upload_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  late TextEditingController _nameCtrl;
  late TextEditingController _nicknameCtrl;
  late TextEditingController _bioCtrl;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final p = _profileService.profile;
    _nameCtrl = TextEditingController(text: p.name);
    _nicknameCtrl = TextEditingController(text: p.nickname);
    _bioCtrl = TextEditingController(text: p.bio);
  }

  void _pickAndUploadPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final Uint8List? bytes = result.files.first.bytes;
      if (bytes != null) {
        setState(() => _isUploadingPhoto = true);

        final String? uploadedUrl = await ImageUploadService.uploadImageToImgur(bytes);

        if (uploadedUrl != null && mounted) {
          final updated = _profileService.profile.copyWith(photoUrl: uploadedUrl);
          await _profileService.updateProfile(updated);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto de perfil atualizada com sucesso!')),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao enviar imagem. Tente novamente.')),
          );
        }

        if (mounted) setState(() => _isUploadingPhoto = false);
      }
    }
  }

  void _saveProfileChanges() async {
    final updated = _profileService.profile.copyWith(
      name: _nameCtrl.text.trim(),
      nickname: _nicknameCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
    );
    await _profileService.updateProfile(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  void _exportUserData() {
    final jsonStr = jsonEncode(_profileService.profile.toJson());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportar Dados do Usuário'),
        content: SingleChildScrollView(
          child: SelectableText(jsonStr),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('☕ Apoie o Desenvolvedor'),
        content: const Text(
          'O Kratos Fit é um projeto 100% gratuito. Se o app te ajuda nos treinos, considere apoiar o desenvolvedor via Pix!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Copiar Chave Pix'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = _profileService.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil & Configurações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfileChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de Perfil com botão de upload
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        backgroundImage: profile.photoUrl.isNotEmpty
                            ? NetworkImage(profile.photoUrl)
                            : null,
                        child: profile.photoUrl.isEmpty
                            ? Icon(Icons.person, size: 64, color: theme.colorScheme.onPrimaryContainer)
                            : null,
                      ),
                      if (_isUploadingPhoto)
                        const Positioned.fill(
                          child: CircularProgressIndicator(),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                            onPressed: _isUploadingPhoto ? null : _pickAndUploadPhoto,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(profile.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text(profile.nickname, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form de Edição Pessoal
            Text('Informações Pessoais', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nicknameCtrl,
              decoration: const InputDecoration(labelText: 'Nickname', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Bio / Frase Motivacional', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            // Personalização de Temas
            Text('Aparência & Estilo', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: profile.isDarkMode,
              onChanged: (val) {
                _profileService.updateProfile(profile.copyWith(isDarkMode: val));
                setState(() {});
              },
            ),

            DropdownButtonFormField<AppThemeStyle>(
              value: profile.themeStyle,
              decoration: const InputDecoration(
                labelText: 'Tema Estilizado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: AppThemeStyle.standard, child: Text('Material Design 3 (Padrão)')),
                DropdownMenuItem(value: AppThemeStyle.cyberpunk, child: Text('Cyberpunk / Neon')),
                DropdownMenuItem(value: AppThemeStyle.synthwave, child: Text('Synthwave 80s')),
                DropdownMenuItem(value: AppThemeStyle.rockMetal, child: Text('Rock / Heavy Metal')),
              ],
              onChanged: (val) {
                if (val != null) {
                  _profileService.updateProfile(profile.copyWith(themeStyle: val));
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),

            // Preferências Gerais
            Text('Preferências Gerais', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: profile.unitSystem,
                    decoration: const InputDecoration(labelText: 'Unidade', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'metric', child: Text('Métrico (kg/cm)')),
                      DropdownMenuItem(value: 'imperial', child: Text('Imperial (lbs/in)')),
                    ],
                    onChanged: (v) {
                      if (v != null) _profileService.updateProfile(profile.copyWith(unitSystem: v));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: profile.language,
                    decoration: const InputDecoration(labelText: 'Idioma', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'pt_BR', child: Text('Português')),
                      DropdownMenuItem(value: 'en_US', child: Text('English')),
                    ],
                    onChanged: (v) {
                      if (v != null) _profileService.updateProfile(profile.copyWith(language: v));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Ações extras
            OutlinedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Exportar Meus Dados (JSON)'),
              onPressed: _exportUserData,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Apoiar o Desenvolvedor / Doar'),
              onPressed: _showDonationDialog,
            ),
          ],
        ),
      ),
    );
  }
}