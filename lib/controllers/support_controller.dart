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
      
      final response = await supabase
          .from('support_tickets')
          .select('*, replies(*)')
          .eq('provider_id', supabase.auth.currentUser?.id)
          .order('created_at', ascending: false)
          .execute();

      if (response.status != 200) {
        throw 'Error: Status ${response.status}';
      }

      tickets.value = (response.data as List)
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

      final response = await supabase
          .from('support_tickets')
          .insert(ticket.toJson())
          .execute();

      if (response.status != 201) {
        throw 'Error: Status ${response.status}';
      }

      await fetchTickets(); // Refresh tickets list
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

      final response = await supabase
          .from('ticket_replies')
          .insert({
            ...reply.toJson(),
            'ticket_id': ticketId,
          })
          .execute();

      if (response.status != 201) {
        throw 'Error: Status ${response.status}';
      }

      await fetchTickets(); // Refresh tickets list
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to add reply: $e';
      return false;
    }
  }
} 