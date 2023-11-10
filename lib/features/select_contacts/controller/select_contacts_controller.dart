import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref){
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
} );

final selectContactControllerProvider = Provider((ref) {
  final SelectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactController(
      selectContactRepository: SelectContactRepository,
      ref: ref
  );
});


class selectContactController{
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  selectContactController({
    required this.selectContactRepository,
    required this.ref,
});
  void selectContact(Contact selectedContact,BuildContext context){
     selectContactRepository.selectContact(selectedContact, context);

  }


}
