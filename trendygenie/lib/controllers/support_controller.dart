import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/support_ticket_model.dart';

class SupportController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<SupportTicket> tickets = <SupportTicket>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<bool> fetchTickets() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User not authenticated';
      }
      
      final response = await supabase
          .from('support_tickets')
          .select('*, replies:ticket_replies(*)')
          .eq('provider_id', userId)
          .order('created_at', ascending: false);


      tickets.value = (response as List)
          .map((json) => SupportTicket.fromJson(json))
          .toList();
      
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to fetch tickets: $e';
      return false;
    }
  }

  Future<bool> submitTicket(String subject, String message) async {
    try {
      isLoading.value = true;
      error.value = '';

      final ticket = SupportTicket(
        subject: subject,
        message: message,
        providerId: supabase.auth.currentUser!.id,
      );

      await supabase
          .from('support_tickets')
          .insert(ticket.toJson());

      await fetchTickets();
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to submit ticket: $e';
      return false;
    }
  }

  Future<bool> addReply(String ticketId, String message) async {
    try {
      isLoading.value = true;
      error.value = '';

      final reply = TicketReply(
        message: message,
        userId: supabase.auth.currentUser!.id,
      );

      await supabase
          .from('ticket_replies')
          .insert({
            ...reply.toJson(),
            'ticket_id': ticketId,
          });

      await fetchTickets();
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to add reply: $e';
      return false;
    }
  }
}
